class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def oktaoauth
      # Please leave the following line of code for debugging Okta session issues
      # session[:oktastate] = request.env["omniauth.auth"]  #store all okta data in session
      session[:netid] = request.env["omniauth.auth"].extra.raw_info.netid
      user = Admin::User.where(username: session[:netid]).first
      if user.present?
        session[:authorized_admin] = true
        sign_in_and_redirect user
      else
        render :unauthorized, status: 401
      end
    end

    protected

    def after_omniauth_failure_path_for resource
      root_path
    end
end
 