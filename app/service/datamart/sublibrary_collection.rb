class Datamart::SublibraryCollection
  include CacheHelper

  def to_json(options = {})
    retrieve_sublibrary_collections.to_json(except: [ :coll_cde, :sublbry_nm ], methods: [ :collection_code, :sublibrary_code ])
  end


  def to_xml(options = {})
    retrieve_sublibrary_collections.to_xml(root: 'sublibrary_collections', dasherize: false)
  end


  def retrieve_sublibrary_collections
    Rails.cache.fetch(cache_key) do
      all_sublibrary_collections
    end
  end

  def all_sublibrary_collections
    Resource::Datamart::SublibraryCollection.all
  end


  def cache_key
    "#{self.class.base_cache_key}".gsub(/\s+/, "")
  end

end
