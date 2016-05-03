class OauthOrganizer
  class OauthError < StandardError
  end

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
    return unless auth_verified?

    find_user_by_identity || find_user_by_email || sign_up_with_oauth
  end

  def find_user_by_identity
    ExistingUserIdentityAuthenticationService.new(@auth, @current_user).call
  end

  def find_user_by_email
    ExistingUserEmailAuthenticationService.new(@auth).call
  end

  def sign_up_with_oauth
    NewUserRegistrationService.new(@auth).call
  end

  def fail_oauth
    fail OauthError,
      "Sorry, but yours #{@auth.provider.titleize} failed verification.
      Seems like yours #{@auth.provider.titleize} account hasn't been verified."
  end

  def connect_accounts!(user)
    return false if identity.user == user

    identity.update_attribute(:user, user)
  end

  def identity
    @_identity ||= Identity.find_for_oauth(@auth)
  end

  def auth_verified?
    AuthVerificationPolicy.new(@auth).public_send(@auth.provider)
  end
end
