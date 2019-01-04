class Admin::ApiPermission
  include CacheHelper

  attr_accessor :consumer, :request, :auth_token

  def initialize(consumer, request)
    @consumer = consumer
    @request  = request
    @auth_token = consumer.authentication_token
  end


  def current_service
    api_admin = Admin::ApiAdmin.new
    @current_service ||= api_admin.determine_service_from_path(request.path)
  end


  def current_consumer
    @consumer
  end


  def service_not_found?
    Rails.cache.fetch("#{self.class.base_cache_key}/not_found_for?-#{request.path}") do
      !current_service
    end
  end


  def consumer_cannot_access_service?
    Rails.cache.fetch("#{self.class.base_cache_key}/access_for_#{auth_token}-#{request.path}") do
      !consumer_can_access_service?
    end
  end


  def request_address_is_internal?
    Admin::InternalLibraryServers.new.ip_address_is_internal?(request.ip)
  end


  private

  def consumer_can_access_service?
    consumer.can_access_service?(current_service)
  end

end
