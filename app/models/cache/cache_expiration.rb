
class Cache::CacheExpiration

  attr_accessor :service

  def initialize(service)
    @service = service
  end


  def expire_service(also_prime_cache = true)
    if service_can_expire_cache?
      service.service_class.constantize.expire_cache

      prime_cache if also_prime_cache
    end
  end


  def prime_cache
    if service_can_prime_cache?
      service.service_class.constantize.prime_cache
    end
  end


  def self.expire_all(also_prime_cache = true)
    Rails.cache.clear
    prime_all_cache if also_prime_cache
  end


  def self.prime_all_cache
    Admin::ApiAdmin.new.list_services.each do | s |
      self.class.new(s).prime_cache
    end
  end


  private

    def service_can_expire_cache?
      service.service_class.constantize.included_modules.include?(CacheHelper)
    end

    def service_can_prime_cache?
      service.service_class.constantize.included_modules.include?(CacheHelper)
    end
end
