require 'spec_helper'

describe Admin::ApiPermission do
  let(:consumer) { FactoryGirl.create(:consumer, :services => [ service ]) }
  let(:service) { FactoryGirl.create(:service, :path => '/identify') }
  let(:request) {
                  r = double(ActionController::TestRequest)
                  r.stub(:path).and_return('/identify')
                  r
                }

  before(:each) do
    consumer
  end

  describe :service_not_found do
    it "returns  if the service exists in the database" do
      ap = Admin::ApiPermission.new(consumer, request)
      ap.service_not_found?.should be_falsey
    end

    it "returns false if the service path is not in the database" do
      r = request
      r.stub(:path).and_return('/some/other/path')

      ap = Admin::ApiPermission.new(consumer, r)
      ap.service_not_found?.should be_truthy
    end

    describe :caching do

      it "caches the request", caching: true do
        ap = Admin::ApiPermission.new(consumer, request)
        ap.stub(:current_service).and_return(true)
        ap.service_not_found?.should be_falsey #prime the cache

        ap2 = Admin::ApiPermission.new(consumer, request)
        ap2.stub(:current_service).and_return(false) # change the result
        ap2.service_not_found?.should be_falsey # should be the same
      end

      it "caches the request based on the path ", caching: true do
        ap = Admin::ApiPermission.new(consumer, request)
        ap.stub(:current_service).and_return(true)
        ap.service_not_found?.should be_falsey #prime the cache

        r = request
        r.stub(:path).and_return('/new/path')

        ap2 = Admin::ApiPermission.new(consumer, r)
        ap2.stub(:current_service).and_return(false) # change the result
        ap2.service_not_found?.should be_truthy # should be different
      end


      it "can be expired" do
        ap = Admin::ApiPermission.new(consumer, request)
        ap.stub(:current_service).and_return(true)
        ap.service_not_found?.should be_falsey #prime the cache

        Admin::ApiPermission.expire_cache

        ap2 = Admin::ApiPermission.new(consumer, request)
        ap2.stub(:current_service).and_return(false) # change the result
        ap2.service_not_found?.should be_truthy # should be different
      end
    end
  end

  describe :no_access_to_service? do
    it "returns false if the consumer has access to the current service" do
      ap = Admin::ApiPermission.new(consumer, request)
      ap.consumer_cannot_access_service?.should be_falsey
    end

    it "returns true if the consumer does not have access to the current service" do
      Admin::ConsumerService.delete_all

      ap = Admin::ApiPermission.new(consumer, request)
      ap.consumer_cannot_access_service?.should be_falsey
    end

    describe :caching do
      it "caches the request", caching: true do
        ap = Admin::ApiPermission.new(consumer, request)
        ap.stub(:consumer_can_access_service?).and_return(true)
        ap.consumer_cannot_access_service?.should be_falsey #prime the cache

        ap2 = Admin::ApiPermission.new(consumer, request)
        ap2.stub(:consumer_can_access_service?).and_return(false) # change the result
        ap2.consumer_cannot_access_service?.should be_falsey # should be the same
      end

      it "caches the result based on auth token ", caching: true do
        ap = Admin::ApiPermission.new(consumer, request)
        ap.stub(:consumer_can_access_service?).and_return(true)
        ap.consumer_cannot_access_service?.should be_falsey #prime the cache

        # change the auth token
        c = consumer
        c.authentication_token = "new token"

        ap2 = Admin::ApiPermission.new(c, request)
        ap2.stub(:consumer_can_access_service?).and_return(false) # change the result
        ap2.consumer_cannot_access_service?.should be_truthy # should be different
      end

      it "caches the result based on request path ", caching: true do
        ap = Admin::ApiPermission.new(consumer, request)
        ap.stub(:consumer_can_access_service?).and_return(true)
        ap.consumer_cannot_access_service?.should be_falsey #prime the cache

        r = request
        r.stub(:path).and_return('/new/path')

        ap2 = Admin::ApiPermission.new(consumer, r)
        ap2.stub(:consumer_can_access_service?).and_return(false) # change the result
        ap2.consumer_cannot_access_service?.should be_truthy # should be different
      end


      it "can be expired", caching: true do
        ap = Admin::ApiPermission.new(consumer, request)
        ap.stub(:consumer_can_access_service?).and_return(true)
        ap.consumer_cannot_access_service?.should be_falsey #prime the cache

        Admin::ApiPermission.expire_cache

        ap2 = Admin::ApiPermission.new(consumer, request)
        ap2.stub(:consumer_can_access_service?).and_return(false) # change the result
        ap2.consumer_cannot_access_service?.should be_truthy # should be the same
      end
    end
  end


  describe :ip_address_can_expire_cache? do
    it "returns true if a request is in the range of the library internal servers " do
      r = request

      true_ips = ["10.41.56.0", "10.41.57.255", "10.41.58.142", "10.41.59.32", "10.41.60.95", "10.41.61.177", "10.41.62.232"]

      true_ips.each do |test_ip|
        r.stub(:ip).and_return(test_ip)
        ap = Admin::ApiPermission.new(consumer, r)

        ap.request_address_is_internal?.should be_truthy
      end
    end


    it "returns false if the request is not in the internal ip range" do
      r = request
      skipped_subnet_values = [56,57,58,59,60,61,62]

      (0...255).each do |subnet|
        next if skipped_subnet_values.include?(subnet)
        test_ip = "10.41.#{subnet}.55"
        r.stub(:ip).and_return(test_ip)
        ap = Admin::ApiPermission.new(consumer, r)

        ap.request_address_is_internal?.should be_falsey
      end
    end


    it "always returns true when the server is in the development environment" do
      r = request
      # Rails.stub!(:env).and_return('development')
      expect(Rails).to receive(:env).and_return('development').at_least :once

      (0...255).each do |subnet|
        test_ip = "10.41.#{subnet}.192"
        r.stub(:ip).and_return(test_ip)
        ap = Admin::ApiPermission.new(consumer, r)

        ap.request_address_is_internal?.should be_truthy
      end


    end
  end

  describe :base_cache_key do
    it "generates an expire cache key"   do
      Admin::ApiPermission.base_cache_key.should == 'admin::apipermission-1'
    end
  end

end

