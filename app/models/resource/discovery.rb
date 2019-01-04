class Resource::Discovery
  include CacheHelper

  attr_reader :search_type, :search_term

  def initialize(search_term, search_type )
    @search_type = search_type
    @search_term = search_term
    search()
  end

  def size
    search['size']
  end

  def records
    search['records']
  end

  def to_hash
    search
  end

  def to_json
    @to_json ||= search.to_json
  end

  def search
    @search ||= Rails.cache.fetch(cache_key, :expires_in => 1.hour) do
      search_object = Resource::Primo::API.new(search_term, search_type)
      @search = search_object.to_hash
    end
    @search
  end

  def cache_key
    "#{self.class.base_cache_key}/#{search_type}/#{search_term}".gsub(/\s+/, "-")
  end

  private
end
