require 'spec_helper'

class ApiTokenTestController < ApiController
  def identify
    render :text => "You have successfully identified as #{current_consumer.name}"
  end

end

describe ApiTokenTestController do
  let(:consumer) { FactoryGirl.create(:consumer, :services => [ service ]) }
  let(:service) { FactoryGirl.create(:service, :path => '/identify') }

  before(:all) do
    Rails.application.routes.draw do
      match 'identify' => 'api_token_test#identify', :as => :identify, via: [:get, :post]
      match 'service_name' => 'api_token_test#service_name', :as => :service, via: [:get, :post]
    end
  end

  after(:all) do
    Rails.application.reload_routes!
  end

  before(:each) do
    consumer
  end

  describe "token access" do

    it "forbids access to a page with no auth token" do
      get :identify
      response.status.should == 401
    end


    it "forbids access to a page with an invalid token" do
      get :identify, :auth_token => 'asdfasfdasfasdfasd'
      response.status.should == 401
    end


    it "forbids access to a service when the service is not connected to the user " do
      Admin::ConsumerService.delete_all

      get :identify, :auth_token => consumer.authentication_token
      response.status.should == 401
    end


    it "returns 404 for a page that does not have a valid service" do
      Admin::Service.delete_all

      get :identify, :auth_token => consumer.authentication_token
      response.status.should == 404
    end


    it "allows access to page with a valid token " do
      get :identify, :auth_token => consumer.authentication_token
      response.status.should == 200
    end
  end


end
