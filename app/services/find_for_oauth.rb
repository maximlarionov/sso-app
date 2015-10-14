class FindForOauth
  def initialize(auth, signed_in_resource = nil)
    @auth = auth
    @signed_in_resource = signed_in_resource
    @identity = Identity.find_for_oauth(auth)
  end

  def call
    user = current_user || authenticate_user
    connect_accounts!(user)

    user
  end

  private

  def current_user
    @signed_in_resource || @identity.user
  end

  def authenticate_user
    sign_in_with_oauth || sign_up_with_oauth
  end

  def sign_in_with_oauth
    ExistingUserEmailAuthenticationService.new(@auth).call
  end

  def sign_up_with_oauth
    NewUserRegistrationService.new(@auth).call
  end

  def connect_accounts!(user)
    return nil if @identity.user == user

    @identity.user = user
    @identity.save!
  end
end
