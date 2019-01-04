class Admin::BaseController < ApplicationController
  before_filter :authenticate_user!

  protected

  def api_admin
    @api_admin ||= Admin::ApiAdmin.new
  end

end
