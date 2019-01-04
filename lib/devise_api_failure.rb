class DeviseApiFailure < Devise::FailureApp

  def respond
    if warden_options[:scope] == :consumer
      # There is no login page for consumers since they must always authenticate using an auth_token
      http_auth
    else
      super
    end
  end
end
