class ApplicationController < ActionController::Base
  include Authentication
  include Authorization

  protect_from_forgery with: :exception
  responders :flash

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == "finish_signup"

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    return false if current_user.try(:email_verified?) != true
    redirect_to finish_signup_path(current_user)
  end
end
