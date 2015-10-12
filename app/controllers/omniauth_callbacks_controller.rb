class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :verify_auth_hash

  expose(:user) { find_for_oauth }

  def facebook
    if user.persisted?
      sign_in_and_redirect user, event: :authentication
      user.send_confirmation_instructions
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
    FindForOauth.new(env["omniauth.auth"], current_user).call
  end

  def verify_auth_hash
    @auth = env["omniauth.auth"]
    verified = @auth.info.verified || @auth.extra.raw_info.verified

    redirect_to new_user_session_path,
      notice: "Your #{@auth.provider.titleize} account is not verified." unless verified
  end
end
