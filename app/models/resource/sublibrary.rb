class Resource::Sublibrary
  include CacheHelper

  def to_json(options = {})
    retrieve_sublibraries.to_json(except: [ :dsc, :sublbry_nm ], methods: [ :code, :name ])
  end


  def to_xml(options = {})
    retrieve_sublibraries.to_xml(root: 'sublibraries', dasherize: false)
  end


  def retrieve_sublibraries
    Rails.cache.fetch(cache_key) do
      #self.class.http_get(uri)
      all_sublibraries
    end
  end

  def all_sublibraries
    Resource::Datamart::Sublibrary.all

  end


  def cache_key
    "#{self.class.base_cache_key}".gsub(/\s+/, "")
  end

end
