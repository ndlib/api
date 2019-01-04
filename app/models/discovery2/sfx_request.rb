class Discovery2::SfxRequest
  INSTITUTION_MAP = {
    'bci' => 'bethel_local',
    'hcc' => 'hcc_local',
    'ndu' => 'ndu_local',
    'ndlaw' => 'ndu_local-law',
    'smc' => 'smc_local',
    'test' => 'sfxtst4'
  }

  attr_reader :params, :original_institution_code

  def initialize(params, original_institution_code)
    if params.is_a?(String)
      params = Rack::Utils.parse_nested_query(params)
    end
    @params = params
    @original_institution_code = original_institution_code
  end

  def connection
    if @connection.nil?
      @connection = Faraday.new(:url => base_url) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        faraday.ssl.verify = false
      end
    end
    @connection
  end

  def institution_code
    @institution_code ||= original_institution_code.to_s.downcase
  end

  def base_url
    'https://findtext.library.nd.edu'
  end

  def url
    "#{base_url}#{base_path}?#{params.to_query}"
  end

  def title
    "FindText"
  end

  def notes
    []
  end

  def service_type
    "SFX"
  end

  def source
    "findtext"
  end

  def link
    @link ||= Discovery2::Record::Link.from_object(self)
  end

  def findtext_link_hash
    link.to_hash
  end

  def fulltext_links
    targets.service_type(:getFullTxt) + targets.service_type(:getSelectedFullTxt)
  end

  def table_of_contents_links
    targets.service_type(:getTOC)
  end

  def ill_link
    targets.service_type(:getDocumentDelivery).first
  end

  def report_a_problem_link
    targets.service_type(:getWebService).first
  end

  def sfx_params
    params.merge({"sfx.response_type" => "multi_obj_detailed_xml", "sid" => "ND:Primo"})
  end

  def sfx_institution
    INSTITUTION_MAP[institution_code]
  end

  def institution
    institution_code
  end

  def base_path
    "/#{sfx_institution}"
  end

  def response
    if @response.nil?
      begin
        puts base_path + "?"+ sfx_params.to_query
        @response = connection.get do |req|
          req.url base_path
          req.params = sfx_params
          req.options.timeout = 7
          req.options.open_timeout = 1
        end
      rescue Faraday::TimeoutError => e
        @response = false
      end
    end
    @response
  end

  def success?
    response != false && !multi_object?
  end

  def body
    if response
      response.body
    else
      nil
    end
  end

  def xml
    if body
      @xml ||= Nokogiri::XML(body)
    else
      nil
    end
  end

  def object_count
    if @object_count.nil?
      if xml
        objects = xml.xpath('//ctx_obj')
        @object_count = objects.length
      else
        @object_count = 0
      end
    end
    @object_count
  end

  def multi_object?
    object_count > 1
  end

  def targets
    if multi_object?
      @targets ||= self.class::Targets.new(nil)
    else
      @targets ||= self.class::Targets.new(xml)
    end
  end

  def to_hash
    targets.to_hash
  end

  def to_json
    to_hash.to_json
  end
end
