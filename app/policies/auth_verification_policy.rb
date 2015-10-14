class AuthVerificationPolicy
  attr_reader :auth, :user

  def initialize(auth)
    @auth = auth
  end

  def facebook
    auth.info.verified || auth.extra.raw_info.verified
  end

  def twitter
    auth.extra.raw_info.verified
  end

  def github
    true
  end

  def google_oauth2
    auth.extra.raw_info.email_verified
  end
end
