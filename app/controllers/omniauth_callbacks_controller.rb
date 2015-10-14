class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :verify_auth_hash
  after_action :connect_accounts

  Identity::PROVIDERS.map(&:to_s).each do |provider|
    define_method("#{provider}") do
      if user.persisted?
        sign_in_and_redirect user, event: :authentication
        set_flash_message(:notice, :success, kind: "#{provider.titleize}") if is_navigational_format?
      else
        session["devise.#{provider}_data"] = auth_hash
        redirect_to new_user_registration_url
      end
    end
  end

  def after_sign_in_path_for(resource)
    if resource.email_verified?
      super resource
    else
      finish_signup_path(resource)
    end
  end

  private

  def identity
    Identity.find_for_oauth(auth_hash)
  end

  def connect_accounts
    return nil if identity.user == user

    identity.user = user
    identity.save!
  end

  def verify_auth_hash
    redirect_to new_user_session_path, notice: auth_policy.notice unless auth_policy.policy
  end

  def auth_policy
    AuthVerificationPolicy.new(auth_hash, user, user_signed_in?).public_send(auth_hash.provider)
  end

  def user
    @user ||= FindForOauth.new(auth_hash, current_user).call
  end

  def auth_hash
    env["omniauth.auth"]
  end
end
