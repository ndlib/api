module FaradayHelpers

  def aleph_rest_connection(&stubs)
    stubs_list = yield(stubs)
    @connection ||= Faraday.new do |connection|
      connection.request :url_encoded
      connection.response :json, :content_type => /\bjson$/
      connection.response :xml, :content_type => /\bxml$/
      connection.adapter :test, stubs_list do |stub|
      end
    end
  end

end
