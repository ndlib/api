class ApiController < ApplicationController
  before_filter :authenticate_api!

  protected

    def authenticate_api!
      remove_consumer_from_session!
      authenticate_consumer!

      if api_permission.service_not_found?
        render_404

      elsif api_permission.consumer_cannot_access_service?
        render_401
      end
    end


    def api_permission
      @api_permission ||= Admin::ApiPermission.new(current_consumer, request)
    end


    def current_service
      @current_service ||= api_permission.current_service
    end


    def remove_consumer_from_session!
      session.delete("warden.user.consumer.key")
    end
end
