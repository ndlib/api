require 'spec_helper'

class TestCache
  include CacheHelper
end

class TestNoCache
end

describe Cache::CacheExpiration do
  let(:service) {FactoryGirl.create(:service, service_class: 'TestCache')}
  let(:service_no_cache) { FactoryGirl.create(:service, service_class: 'TestNoCache')}
  let(:cache_expiration) { Cache::CacheExpiration.new(service)}
  let(:cache_expiration_no_cache) { Cache::CacheExpiration.new(service_no_cache)}

  describe "#expire_cache" do
    it "calls the expiration method on the service class" do
      service.service_class.constantize.should_receive(:expire_cache)
      cache_expiration.expire_service
    end


    it "only expires services that implement cache helper" do
      service.service_class.constantize.should_not_receive(:expire_cache)
      cache_expiration_no_cache.expire_service
    end


    it "primes the cache after expiration" do
      service.service_class.constantize.should_receive(:prime_cache)
      cache_expiration.expire_service
    end


    it "allows for passing the priming step" do
      service.service_class.constantize.should_not_receive(:prime_cache)
      cache_expiration.expire_service(false)
    end
  end

  describe "#expire_all" do
    it "removes all cache from the site" do
      Rails.cache.should_receive(:clear)
      Cache::CacheExpiration.expire_all
    end
  end

end
