class ApplicationController < ActionController::Base
  # Sentry
  before_action :set_raven_context

  # these are used to allow cross site scripting in the development environment
  # Access-Control-Allow-Origin is being set in apache for prod / preprod
  after_filter :set_access_control_headers

  def set_access_control_headers
    headers['Cache-Control'] = 'must-revalidate, no-cache, max-age=0'

    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = 'PUT, GET, POST, DELETE, OPTIONS'
  end

  # Okta
  def login_user!
    if !session[:netid] || !session[:authorized_admin]
      redirect_to user_oktaoauth_omniauth_authorize_path
    end
  end

  protect_from_forgery

  protected

    def render_404
      respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/404.html", :status => :not_found }
        format.any  { head :not_found }
      end
    end

    def render_404_json
      respond_to do |format|
        format.any { render :json => {status: "404", message: "Not Found"}.to_json, :status => :not_found }
      end
    end


    def render_401
      respond_to do |format|
        format.html { render :text => "", :status => 401 }
        format.any  { head 401 }
      end
    end

  private

   def set_raven_context
    Raven.user_context(id: session[:current_user_id]) # or anything else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
