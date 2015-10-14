class AuthVerificationPolicy
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def facebook
    auth.info.verified || auth.extra.raw_info.verified
  end

  def twitter
    auth.extra.raw_info.verified
  end

  # fix me: GitHub has untrustworthy access
  def github
    true
  end

  def google_oauth2
    auth.extra.raw_info.email_verified
  end
end
