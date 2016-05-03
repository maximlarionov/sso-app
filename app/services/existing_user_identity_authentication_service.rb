class ExistingUserIdentityAuthenticationService
  def initialize(auth, signed_in_user = nil)
    @auth = auth
    @signed_in_user = signed_in_user
    @identity = Identity.find_by(uid: @auth.uid, provider: @auth.provider)
  end

  def call
    user = @signed_in_user || @identity.try(:user)

    user
  end
end
