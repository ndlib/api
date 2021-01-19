require 'spec_helper'

class AdminAuthenticationController < Admin::BaseController
  def identify
    render :text => current_user.name
  end

  def fake_controller_method
    render :text => 'null'
  end
end

describe AdminAuthenticationController do

  # let(:login_user) {FactoryGirl.create(:user)}

  before(:all) do
    Rails.application.routes.draw do
      match '/identify' => 'admin_authentication#identify', :as => :identify, via: [:get, :post]
      match '/fake_controller_method' => 'admin_authentication#fake_controller_method', :as => :fake_controller_method, via: [:get, :post]
    end
  end

  after(:all) do
    Rails.application.reload_routes!
  end

  describe "logged in user " do

    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @login_user = FactoryGirl.create(:user)
      session[:netid] = OmniAuth.config.mock_auth[:okta].netid
      session[:authorized_admin] = true
      login_user
    end


    it "allows access to logged in users" do
      get :identify
      response.status.should == 200
    end


    it "the logged in user is the one that we logged in as" do
      get :identify
      response.body.should == @login_user.name
    end

  end

  describe "not logged in" do

    it "redirects when the user is not logged in" do
      ApplicationController.any_instance.should_receive(:login_user!)
      get :fake_controller_method
    end


  end

end
