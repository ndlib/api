
module CacheHelper

  def self.included(base)
    base.extend ClassMethods
  end


  module ClassMethods

    # use this method to expire all the cache that is prefixed with the #base_cache_key
    def expire_cache(params = {})
      increment_klass_namespaced_cache_key
    end


    def expire_individual_cache(cache_key)
      Rails.cache.delete(cache_key)
    end


    def prime_cache
      # empty add lines to prime any cache you want
    end
    

    def base_cache_key
      "#{kclass_base_cache_key}-#{klass_namespaced_cache_key}"
    end


    private
    
    def klass_namespaced_cache_key
      get_current_namespaced_key 
    end


    def get_current_namespaced_key
      Rails.cache.fetch(increment_namespaced_cache_key) do
        1
      end
    end


    def increment_klass_namespaced_cache_key
      new_cache_key = get_current_namespaced_key + 1
      Rails.cache.write(increment_namespaced_cache_key, new_cache_key)
    end


    def increment_namespaced_cache_key
      "klass_namespaced_cache_key_#{kclass_base_cache_key}"
    end


    def kclass_base_cache_key
      self.name.downcase
    end

  end

end 
