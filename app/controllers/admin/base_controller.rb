class Admin::BaseController < ApplicationController
  before_filter :login_user!

  protected

  def api_admin
    @api_admin ||= Admin::ApiAdmin.new
  end

end
