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
    # since github oauth doesn't return unconfirmed emails
    # https://github.com/intridea/omniauth-github/issues/36

    auth.extra.raw_info.email.present?
  end

  def google_oauth2
    auth.extra.raw_info.email_verified
  end
end
