class Discovery2::PrimoAPIRecord::OpenUrlQuery
  attr_reader :record

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
    "edition",
    "eissn",
    "epage",
    "genre",
    "isbn",
    "issn",
    "issue",
    "jtitle",
    "lccn",
    "pages",
    "part",
    "place",
    # "pub",
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


  def initialize(record)
    @record = record
  end

  def fields
    if @fields.nil?
      @fields = {}
      OPENURL_FIELDS.each do |field|
        if value = get(field)
          @fields[field] = value
        end
      end
    end

    @fields
  end

  def query_hash
    if @query_hash.nil?
      @query_hash = {
        "ctx_ver" => 'Z39.88-2004',
        "ctx_enc" => 'info:ofi/enc:UTF-8',
        "ctx_tim" => Time.now.strftime('%FT%T%Z')
      }
      fields.each do |key,value|
        @query_hash["rft.#{key}"] = value
      end
      if get('oclcid')
        @query_hash["rft.oclcnum"] = get('oclcid')
      end
      if doi
        @query_hash["rft_id"] = "info:doi/#{doi}"
      end
      add_gale_ofg(@query_hash)
      if record.display_type == "journal"
        @query_hash["sfx.ignore_date_threshold"] = "1"
      end
    end
    @query_hash
  end

  def add_gale_ofg(hash)
    if gale_ofg?
      hash["rfr_id"] = "info:sid/primo.exlibrisgroup.com:primo3-Article-gale_ofg"
      hash["rft_dat"] = "<gale_ofg>#{sourcerecordid}</gale_ofg>"
    end
  end

  def gale_ofg?
    get("lad01") == "gale_ofg" && sourcerecordid
  end


  def to_query
    query_hash.to_query
  end


  private

    def get(field)
      method = "addata_#{field}"
      if record.respond_to?(method)
        record.send(method)
      end
    end

    def sourcerecordid
      if record.respond_to?("control_sourcerecordid")
        record.send("control_sourcerecordid")
      end
    end


    def doi
      return @doi if @doi

      @doi = Discovery2::PrimoAPIRecord::Identifiers.new(record).doi
      if @doi.is_a?(Array)
        @doi = @doi.first
      end

      @doi
    end
end
