class Location::Maps
  include HttpRequestHelper
  include CacheHelper


  def initialize(params)
    @params = params
  end


  def to_json(options = {})
    retrieve_maps
  end


  def to_xml(options = {})
    { :map => ActiveSupport::JSON.decode(retrieve_maps)}.to_xml(root: 'stack_maps', dasherize: false)
  end


  def retrieve_maps
    Rails.cache.fetch(cache_key) do
      self.class.http_get(uri)
    end
  end


  def cache_key
    "#{self.class.base_cache_key}/#{pass_on_request_params}".gsub(/\s+/, "")
  end


  private

    def uri
      base_uri = Rails.configuration.api_backend_maps

      "#{base_uri}?#{pass_on_request_params}"
    end


    def pass_on_request_params
      @params.slice(:call_number, :sublibrary, :collection, :library, :floor ).to_param
    end
end
