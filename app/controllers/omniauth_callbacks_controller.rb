class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  expose(:user) { find_for_oauth }

  def facebook
    if user.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def after_sign_in_path_for(resource)
    if resource.email_verified? && resource.confirmed?
      super resource
    else
      finish_signup_path(resource)
    end
  end

  private

  def find_for_oauth
    FindForOauth.new(current_user, env["omniauth.auth"])
  end
end
