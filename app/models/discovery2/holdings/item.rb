class Discovery2::Holdings::Item
  attr_reader :record_xml, :item_url

  def initialize(record_xml)
    @record_xml = record_xml
    @item_url = @record_xml.xpath("//item/@href").to_s
  end

  def to_hash
    {
      description: xpath("//item/z30/z30-description"),
      due_date: 'due_date',
      requested: 'requested',
      call_number: xpath("//item/z30/z30-call-no"),
      url: item_url,
    }
  end

  def due_date

  end

  private

  def xpath(path)
    xml.xpath(path).inner_text
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

  def connection
    if @connection.nil?
      @connection = Faraday.new(:url => item_url) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end
    @connection
  end

  def response
    if !@response
      begin
        @response = send_request
      rescue Faraday::TimeoutError => e
        @response = send_request(10)
      end
    end
    @response
  end

  def send_request(timeout = 3)
    connection.get do |req|
      req.url item_url
      req.options.timeout = timeout
      req.options.open_timeout = 1
    end
  end
end
