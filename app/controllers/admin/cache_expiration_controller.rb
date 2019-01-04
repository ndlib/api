class Admin::CacheExpirationController < Admin::BaseController


  def expire_all_cache
    Cache::CacheExpiration.expire_all

    flash[:notice] = "Site Cache expired"

    redirect_to admin_services_path
  end


  def expire_service_cache
    service = api_admin.get_service(params[:service_id])
    cache_expiration = Cache::CacheExpiration.new(service)

    cache_expiration.expire_service

    flash[:notice] = "Cache expired for #{service.name}"

    redirect_to admin_services_path
  end

end
