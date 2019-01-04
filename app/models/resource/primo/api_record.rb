class Resource::Primo::APIRecord
  # Primo full view deep link: http://www.exlibrisgroup.org/display/PrimoOI/Full+View+%28Deep+Link%29
  FULL_VIEW_DEEP_LINK = "/primo_library/libweb/action/dlDisplay.do"
  attr_reader :record, :search, :index

  def initialize(record, search_instance, index = 0)
    @search = search_instance
    @record = record
    @index = index
  end

  def get(field)
    if record.respond_to?(field)
      record.send(field)
    end
  end

  def id
    get(:control_recordid)
  end

  def record_type
    get(:display_type)
  end

  def title
    get(:display_title)
  end

  def publisher_provider
    display_publisher || get(:display_source)
  end

  def display_publisher
    if publisher = get(:display_publisher)
      if get(:display_creationdate)
        publisher += " #{get(:display_creationdate)}"
      end
      publisher
    end
  end

  def creator_contributor
    "#{get(:display_creator)} #{contributor}".strip
  end

  def contributor
    if @contributor.nil?
      contributors = []
      xpath('display/contributor').each do |field|
        contributors << field.inner_text.strip
      end
      @contributor = contributors.join(" ").strip
      if @contributor.blank?
        @contributor = nil
      end
    end
    @contributor
  end

  def display_details
    if @display_details.nil?
      @display_details = "#{get(:display_ispartof)}"
      if get(:display_lds50) == "peer_reviewed"
        @display_details += " [Peer Reviewed Journal]"
      end
      @display_details.strip!
    end
    @display_details

  end

  def isbn
    get(:addata_isbn)
  end

  def issn
    get(:addata_issn)
  end

  def oclc
    get(:addata_oclcid)
  end

  def lccn
    get(:addata_lccn)
  end

  def doi
    get(:addata_doi)
  end

  def fulltext
    get(:delivery_fulltext)
  end

  def electronic?
    match = delivery_categories & ["Remote Search Resource","Online Resource","SFX Resource","MetaLib Resource"]
    match.present?
  end

  def fulltext_available?
    (fulltext.to_s =~ /^fulltext/).present? || get(:fulltexts).present?
  end

  def physical?
    match = delivery_categories & ["Physical Item","Microform"]
    match.present?
  end

  def physical_available?
    get(:display_availpnx) == "available"
  end

  def delivery
    if @delivery.nil?
      record_delivery = {}
      xpath('delivery/*').each do |field|
        name = field.name
        unparsed = field.inner_text.to_s.strip
        if has_subfields?(unparsed)
          hash = parse_subfields(unparsed)
          record_id = hash["O"]
          value = hash["V"]
        else
          record_id = self.id
          value = unparsed
        end
        record_delivery[record_id] ||= {"id" => record_id}
        record_delivery[record_id][name] = value
      end
      @delivery = []
      record_delivery.each do |record_id, hash|
        @delivery << hash
      end
    end
    @delivery
  end

  def delivery_categories
    @delivery_categories ||= delivery.collect{|d| d["delcategory"]}.uniq
  end

  def detail_url
    "#{search.class.base_url}#{FULL_VIEW_DEEP_LINK}?#{detail_url_query}"
  end

  def detail_url_query
    doc_query = {
      docId: id,
      indx: index+1
    }.to_query
    "#{search.record_url_query}&#{doc_query}"
  end

  def fulltext_url
    @fulltext_url ||= build_fulltext_url
  end

  def build_fulltext_url
    if ["fulltext", "no_fulltext"].include?(fulltext)
      query = {
        "ctx_ver" => 'Z39.88-2004',
        "ctx_enc" => 'info:ofi/enc:UTF-8',
        "ctx_tim" => Time.now.strftime('%FT%T%Z')
      }
      openurl.each do |key,value|
        query["rft.#{key}"] = value
      end
      if doi
        query["rft_id"] = "info:doi/#{doi}"
      end
      "#{Rails.application.config.findtext_url}?#{query.to_query}"
    elsif get(:fulltexts).present?
      get(:fulltexts).first.url
    end
  end

  def fulltext_url_name
    if electronic?
      if fulltext_available?
        "Access Online"
      else
        "FindText"
      end
    end
  end

  def display_type
    if @display_type.nil?
      @display_type = record_type.gsub('_',' ')
      @display_type = @display_type.slice(0,1).capitalize + @display_type.slice(1..-1)
      @display_type
    end
    @display_type
  end

  def display_available_library
    selectedHoldings = holdings_to_hash.detect{|h| h["institution_code"] == "NDU" && h["library_code"] == "HESB"} || holdings_to_hash.first
    if selectedHoldings.present?
      "#{selectedHoldings["short_institution_name"]}, #{selectedHoldings["library"]} #{selectedHoldings["collection"]} #{selectedHoldings["call_number"]}"
    end
  end

  def display_availability
    if physical?
      if physical_available?
        "Available"
      else
        "Not Available"
      end
    elsif electronic?
      if fulltext_available?
        "Online access available"
      else
        "See FindText for options"
      end
    end
  end


  def display
    if @display.nil?
      @display = {
        "type" => display_type,
        "title" => title,
        "creator_contributor" => creator_contributor,
        "details" => display_details,
        "publisher_provider" => publisher_provider,
        "availability" => display_availability,
        "available_library" => display_available_library
      }
      @display.delete_if {|k,v| v.blank?}
    end
    @display
  end

  def links
    if @links.nil?
      @links = {
        "detail_url" => detail_url,
        "fulltext_url" => fulltext_url,
        "fulltext_url_name" => fulltext_url_name
      }
      @links.delete_if {|k,v| v.blank?}
    end
    @links
  end

  def holdings
    record.holdings
  end

  def holdings_to_hash
    array = []
    # Primo Technical Guide: availlibrary
    holdings.each do |h|
      hash = {
        "record_id" => h.original_id,
        "institution" => search.class.institution_name(h.institution_code),
        "short_institution_name" => search.class.short_institution_name(h.institution_code),
        "library" => search.class.library_name(h.library_code)
      }
      [
        "institution_code",
        "library_code",
        "collection",
        "call_number",
        "availability_status_code"
      ].each do |field|
        hash[field] = h.send(field)
      end
      {
        "4" => "number_of_items",
        "5" => "multi_volume",
        "6" => "number_of_loans",
        "9" => "online",
        "X" => "source_institution_code",
        "Y" => "source_library_code",
        "Z" => "source_sublocation_code"
      }.each do |subfield,field_name|
        if h.subfields[subfield]
          hash[field_name] = h.subfields[subfield]
        end
      end
      array << hash
    end
    array
  end

  def openurl
    if @openurl.nil?
      @openurl = {}
      OPENURL_FIELDS.each do |field|
        method = "addata_#{field}"
        if value = get(method)
          @openurl[field] = value
        end
      end
    end
    @openurl
  end

  def openurl_with_doi
    if doi.present?
      openurl.merge({"doi" => doi})
    else
      openurl
    end
  end

  def base_hash
    if @base_hash.nil?
      @base_hash = {
        "id" => id,
        "type" => record_type,
        "oclc" => oclc,
        "lccn" => lccn,
        "physical" => physical?,
        "physical_available" => physical_available?,
        "electronic" => electronic?,
        "fulltext_available" => fulltext_available?,
      }
      @base_hash.delete_if {|k,v| v.nil?}
    end
    @base_hash
  end

  def to_hash
    @to_hash ||= base_hash.merge({
      "display" => display,
      "links" => links,
      "holdings" => holdings_to_hash,
      "openurl" => openurl_with_doi,
      "primo" => record.to_hash["record"]
    })
  end

  def to_json
    to_hash.to_json
  end

  def xpath(*args)
    record.send(:xml).root.xpath(*args)
  end
  private :xpath

  def has_subfields?(string)
    (string =~ /^\${2}/).present?
  end
  private :has_subfields?

  def parse_subfields(string)
    Hash[string.scan(/\${2}([^\$])([^\$]+)/)]
  end
  private :parse_subfields

  # OpenURL specification: http://support.gale.com/al/12/1/article.asp?aid=1225&c=12&cp=10&cpc=WnaqEcP5KrNu623S1OAR4DxwrR4VyhK7fv2yl3XXS#10
  OPENURL_FIELDS = [
    "artnum",
    "atitle",
    "au",
    "aufirst",
    "auinit",
    "auinit1",
    "auinitm",
    "aulast",
    "bici",
    "btitle",
    "coden",
    "date",
    "edition ",
    "eissn",
    "epage",
    "genre",
    "isbn",
    "issn",
    "issue",
    "jtitle",
    "pages",
    "part",
    "place",
    "pub",
    "quarter",
    "series",
    "sici",
    "sid",
    "spage",
    "ssn",
    "stitle",
    "title",
    "volume"
  ]
end
