require 'spec_helper'

describe Admin::ApiAdmin do
  let(:api_admin) { Admin::ApiAdmin.new }
  let(:service) { FactoryGirl.create(:service) }
  let(:consumer) { FactoryGirl.create(:consumer) }
  let(:user) { FactoryGirl.create(:user) }

  let(:service_list) { FactoryGirl.create_list(:service, 3) }
  let(:consumer_list) { FactoryGirl.create_list(:consumer, 3) }
  let(:user_list) { FactoryGirl.create_list(:user, 3) }

  let(:valid_service_params)  { {:name => 'Name', :path => 'Path', :service_class => 'Object', :code => 'code'}}
  let(:update_service_params) { {:name => 'New Name', :path => 'New Path', :service_class => 'Object',  :code => 'code' }}

  let(:valid_consumer_params)  { {:name => 'Name' }}
  let(:update_consumer_params) { {:name => 'New Name' }}

  let(:valid_user_params)  { {:name => 'Name', :username => 'username'}}
  let(:update_user_params) { {:name => 'New Name', :username => 'username'}}

  describe :get_service_by_code do
    it "finds a service by the code " do
      api_admin.get_service_by_code(service.code).should == service
    end
  end


  describe :determine_service_from_path do
    it "finds the service with an exact path match " do
      api_admin.determine_service_from_path(service.path).should == service
    end

    it "finds the service with a filename extension on the end " do
      api_admin.determine_service_from_path("#{service.path}.json").should == service
    end

    it "finds the service with a % wildcard for variables at the end " do
      s = FactoryGirl.create(:service, :path => '/path/to/service/%')
      api_admin.determine_service_from_path('/path/to/service/idofthingy').should == s
    end

    it "finds the service with a % wildcard in the middle of the path" do
      s = FactoryGirl.create(:service, :path =>'/path/%/service')
      api_admin.determine_service_from_path('/path/idofthingy/service').should == s
    end
  end

  describe :services do
    it "returns all the current services" do
      service_list
      api_admin.list_services.size.should == 3
    end

    it "orders all the services by the name" do
      service_list
      sl = Admin::Service.order(:name)

      api_admin.list_services.should == sl
    end
  end

  describe :service do
    it "returns the service ided in the call " do
      service
      api_admin.get_service(service.id).should == service
    end

    it "returns a new object when no id is passed in " do
      api_admin.get_service().new_record?.should be_truthy
    end
  end

  describe :add_service do
    it "saves a valid service" do
      s = api_admin.add_service(valid_service_params)
      s.valid?.should == true

    end

    it "returns the new service it has added " do
      s = api_admin.add_service(valid_service_params)
      s.class.should be Admin::Service
    end

    it "invalidates the api permission cache" do
      Admin::ApiPermission.should_receive(:expire_cache)
      api_admin.add_service(valid_service_params)
    end
  end

  describe :update_service do
    it "updates a valid record with valid data" do
      s = api_admin.update_service(service.id, update_service_params)
      s.valid?.should == true
    end


    it "invalidates the api permission cache" do
      service # needed because otherwise the service may trigger an expire cache call
      Admin::ApiPermission.should_receive(:expire_cache)
      api_admin.update_service(service.id, update_service_params)
    end
  end

  describe :destroy_service do

    it "destroys the service" do
      service
      expect {
        api_admin.destroy_service(service.id)
      }.to change(Admin::Service, :count).by(-1)
    end

    it "invalidates the api permission cache" do
      service # needed because otherwise the service may trigger an expire cache call
      Admin::ApiPermission.should_receive(:expire_cache)
      api_admin.destroy_service(service.id)
    end
  end


  describe :consumers do
    it "returns all the current consumers" do
      consumer_list
      api_admin.list_consumers.size.should == 3
    end

    it "orders all the consumers by the name" do
      consumer_list
      cl = Admin::Consumer.order(:name)

      api_admin.list_consumers.should == cl
    end
  end

  describe :consumer do
    it "returns the consumer ided in the call " do
      consumer
      api_admin.get_consumer(consumer.id).should == consumer
    end

    it "returns a new object when no id is passed in " do
      api_admin.get_consumer().new_record?.should be_truthy
    end
  end

  describe :add_consumer do
    it "saves a valid consumer" do
      s = api_admin.add_consumer(valid_consumer_params)
      s.valid?.should == true
    end

    it "returns the new consumer it has added " do
      s = api_admin.add_consumer(valid_consumer_params)
      s.class.should be Admin::Consumer
    end

    it "invalidates the api permission cache" do
      Admin::ApiPermission.should_receive(:expire_cache)
      api_admin.add_consumer(valid_consumer_params)
    end
  end

  describe :update_consumer do
    it "updates a valid record with valid data" do
      s = api_admin.update_consumer(consumer.id, update_consumer_params)
      s.valid?.should == true
    end


    it "invalidates the api permission cache" do
      consumer # needed because otherwise the consumer may trigger an expire cache call
      Admin::ApiPermission.should_receive(:expire_cache)
      api_admin.update_consumer(consumer.id, update_consumer_params)
    end
  end

  describe :destroy_consumer do

    it "destroys the consumer" do
      consumer

      expect {
        api_admin.destroy_consumer(consumer.id)
      }.to change(Admin::Consumer, :count).by(-1)
    end


    it "invalidates the api permission cache" do
      consumer # needed because otherwise the consumer may trigger an expire cache call
      Admin::ApiPermission.should_receive(:expire_cache)
      api_admin.destroy_consumer(consumer.id)
    end
  end


  describe :users do
    it "returns all the current users" do
      user_list
      api_admin.list_users.size.should == 3
    end

    it "orders all the users by the name" do
      user_list
      cl = Admin::User.order(:name)

      api_admin.list_users.should == cl
    end
  end

  describe :user do
    it "returns the user ided in the call" do
      user
      api_admin.get_user(user.id).should == user
    end

    it "returns a new object when no id is passed in " do
      api_admin.get_user().new_record?.should be_truthy
    end
  end

  describe :add_user do
    it "saves a valid user" do
      s = api_admin.add_user(valid_user_params)
      s.valid?.should == true

    end

    it "returns the new user it has added " do
      s = api_admin.add_user(valid_user_params)
      s.class.should be Admin::User
    end
  end

  describe :update_user do
    it "updates a valid record with valid data" do
      s = api_admin.update_user(user.id, update_user_params)
      s.valid?.should == true
    end
  end

  describe :destroy_user do

    it "destroys the user" do
      user

      expect {
        api_admin.destroy_user(user.id)
      }.to change(Admin::User, :count).by(-1)
    end

  end
end

