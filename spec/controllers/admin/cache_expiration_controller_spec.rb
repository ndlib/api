require 'spec_helper'

class TestClass
  include CacheHelper
end

describe Admin::CacheExpirationController do

  describe "#expire_all_cache" do
    before(:each) do
      login_user
    end

    it "expires all the cache on the site" do
      Cache::CacheExpiration.should_receive(:expire_all)
      get :expire_all_cache
    end

    it "redirects to the root of the admin section " do
      get :expire_all_cache
      response.should be_redirect
      response.should redirect_to(admin_services_path)
    end
  end

  describe "#expire_service_cache" do
    before(:each) do
      login_user
    end

    let(:service) {FactoryGirl.create(:service, service_class: 'TestClass')}

    it "expires the cache of the service" do
      Cache::CacheExpiration.any_instance.should_receive(:expire_service)
      get :expire_service_cache, service_id: service.id
    end

    it "redirects to the root of the admin section" do
      get :expire_service_cache, service_id: service.id
      response.should be_redirect
      response.should redirect_to(admin_services_path)
    end
  end
end
