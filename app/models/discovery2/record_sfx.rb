class Discovery2::RecordSfx
  attr_reader :record, :institution_code

  def initialize(record, institution_code)
    @record = record
    @institution_code = Discovery2::Institution.format_code(institution_code)
  end

  def openurl_query
    if openurl_link.present?
      openurl_link.query
    else
      record.openurl_query
    end
  end

  def openurl_link
    @openurl_link ||= institution_links.findtext
  end

  def fulltext_links
    institution_links.fulltext
  end

  def online_access_object
    record.online_access
  end

  def institution_links
    @institution_links ||= online_access_object.institution(institution_code)
  end

  def sfx_request
    @sfx_request ||= Discovery2::SfxRequest.new(openurl_query, institution_code)
  end

  def convert_link(sfx_link)
    if sfx_link_valid?(sfx_link)
      link = Discovery2::Record::Link.new()
      link.title = sfx_link.title
      link.url = sfx_link.url
      # uncomment for service now form
      #link.url = "https://nd.service-now.com/ess/create_lib_incident.do?"
      link.notes = sfx_link.notes unless record.type == 'article'
      link.source = sfx_link.source
      link.service_type = sfx_link.service_type
      link
    else
      nil
    end
  end

  def all_sfx_links_converted(sfx_links)
    sfx_links.collect{|link| convert_link(link)}.compact
  end

  def sfx_link_valid?(sfx_link)
    if sfx_link.present?
      if sfx_link.url.nil? || sfx_link.url.empty?
        text = "Missing URL from SFX. title: #{sfx_link.title}.  It is probably a \"target cannot be generated\" error."
        EventNotifier.notify(text, record).deliver
        return false
      end
      return true
    end
    return false
  end

  def findtext_link
    if @findtext_link.nil?
      link = institution_links.findtext || build_findtext_link
      @findtext_link = link
    end
    @findtext_link
  end

  def build_findtext_link
    link = Discovery2::Record::Link.new()
    link.title = "FindText"
    link.url = sfx_request.url
    link.source = "SFX"
    link.service_type = "SFX"
    Discovery2::Record::SFXLink.new(link)
  end

  def merge_sfx_links(sfx_links, original_links)
    original_links.merge(all_sfx_links_converted(sfx_links))
  end

  def add_fulltext_links
    merge_sfx_links(sfx_request.fulltext_links, institution_links.fulltext)
  end

  def add_table_of_contents_links
    merge_sfx_links(sfx_request.table_of_contents_links, institution_links.table_of_contents)
  end

  def add_links
    if record.present?
      add_fulltext_links
      add_table_of_contents_links
      institution_links.ill = convert_link(sfx_request.ill_link)
      institution_links.report_a_problem = convert_report_a_problem_link(sfx_request)
      findtext_link.targets_loaded = sfx_request.success?
      findtext_link.number_of_targets = sfx_request.fulltext_links.count
      institution_links.findtext = findtext_link
    end
  end


  def convert_report_a_problem_link(sfx_request)
    link = convert_link(sfx_request.report_a_problem_link)
    return nil if link.nil?
    params = "referrer=http://onesearch.library.nd.edu/#{institution_code.upcase}:#{record.id}"
    # uncomment for service now form.
    # params = "lib_list_problem=lib_list_catalog&system_number=#{record.id}"
    link.url += params

    link
  end

  def self.add_links(record, institution_code)
    record_sfx = new(record, institution_code)
    record_sfx.add_links
    record_sfx
  end
end
