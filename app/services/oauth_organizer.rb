class OauthOrganizer
  def initialize(auth, current_user)
    @auth = auth
    @current_user = current_user
  end

  def call
    user = build_response
    user.present? ? connect_accounts!(user) : fail_oauth

    user
  end

  private

  def build_response
    response = find_user_by_identity || find_user_by_email || sign_up_with_oauth

    response
  end

  def find_user_by_identity
    ExistingUserIdentityAuthenticationService.new(@auth, @current_user).call if auth_verified?
  end

  def find_user_by_email
    ExistingUserEmailAuthenticationService.new(@auth).call if auth_verified? && trustworthy_for_sign_in?
  end

  def found_user_by_email?
    ExistingUserEmailAuthenticationService.new(@auth).call.present?
  end

  def sign_up_with_oauth
    NewUserRegistrationService.new(@auth).call if auth_verified? && !found_user_by_email? && !trustworthy_for_sign_up?
  end

  def fail_oauth
    fail ArgumentError, "Verification checking is not implemented for provider: '#{@auth.provider}'"
  end

  def connect_accounts!(user)
    identity = Identity.find_for_oauth(@auth)
    return false if identity.user == user

    identity.update_attribute(:user, user)
  end

  def auth_verified?
    AuthVerificationPolicy.new(@auth).public_send(@auth.provider)
  end

  def trustworthy_for_sign_in?
    ProviderTrustPolicy.new(@auth, @current_user).trustworthy?
  end

  def trustworthy_for_sign_up?
    ProviderTrustPolicy.new(@auth, @current_user).trustworthy_for_sign_up?
  end
end