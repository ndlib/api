require 'spec_helper'

class Admin::Service
end

describe Locations::HoursController do

  let(:response_json) { "JSON RESPONSE !!!!"}
  let(:consumer) { FactoryGirl.create(:consumer, :services => [ service ]) }
  let(:service) { FactoryGirl.create(:service, :path => '/1.0/locations/hours', :service_class => 'Location::Hours') }


  before(:each) do
    Location::Hours.stub(:http_get).and_return(response_json)
    consumer
  end


  describe "date parameter" do
    it "does not require a date parameter" do
      get :index, {auth_token: consumer.authentication_token }
      response.status.should == 200
      response.body.should == response_json
    end

    it "can accept a date parameter" do
      get :index, {:date => Date.today, auth_token: consumer.authentication_token}
      response.status.should == 200
      response.body.should == response_json
    end
  end

  describe "codes parameter" do

    it "does not require a codes parameter" do
      get :index, {auth_token: consumer.authentication_token}
      response.status.should == 200
      response.body.should == response_json
    end

    it "can accept a code parameter" do
      get :index, {codes: "code,code2", auth_token: consumer.authentication_token}
      response.status.should == 200
      response.body.should == response_json
    end

    it "accepts code in place of codes" do
      get :index, {code: "code", auth_token: consumer.authentication_token}
      response.status.should == 200
      response.body.should == response_json
    end
  end

end
