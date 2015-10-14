class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  Identity::PROVIDERS.map(&:to_s).each do |provider|
    define_method("#{provider}") do
      begin
        handle_user(user_from_oauth, provider)
      rescue ArgumentError
        redirect_to new_user_session_path,
          notice: "Your #{provider.titleize} account is not verified. Please verify it via profile page."
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

  def handle_user(user, provider)
    if user.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: "#{provider.titleize}") if is_navigational_format?
    else
      session["devise.#{provider}_data"] = auth_hash
      redirect_to new_user_registration_url
    end
  end

  def user_from_oauth
    @user ||= OauthOrganizer.new(auth_hash, current_user).call
  end

  def auth_hash
    env["omniauth.auth"]
  end
end
