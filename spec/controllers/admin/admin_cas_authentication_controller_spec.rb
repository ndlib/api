require 'spec_helper'

class AdminCasAuthenticationController < Admin::BaseController
  def identify
    render :text => current_user.name
  end
end

describe AdminCasAuthenticationController do

  # let(:login_user) {FactoryGirl.create(:user)}

  before(:all) do
    Rails.application.routes.draw do
      match '/identify' => 'admin_cas_authentication#identify', :as => :identify, via: [:get, :post]
    end
  end

  after(:all) do
    Rails.application.reload_routes!
  end

  describe "logged in user " do

    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @login_user = FactoryGirl.create(:user)
      sign_in @login_user
    end

    after(:each) do
      sign_out @login_user
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
      get :identify
      response.status.should == 302
    end


  end

end
