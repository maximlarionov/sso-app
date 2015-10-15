class ProviderTrustPolicy
  attr_reader :auth, :user
  private :auth, :user

  UNTRUSTWORTHY_PROVIDERS = %w(github)

  def initialize(auth, user)
    @auth = auth
    @user = user
  end

  def trustworthy?
    send(auth.provider)
  end

  def trustworthy_for_sign_up?
    UNTRUSTWORTHY_PROVIDERS.include?(auth.provider)
  end

  private

  def facebook
    true
  end

  def google_oauth2
    true
  end

  def github
    return false unless user

    user.identities.map(&:provider).include?(auth.provider)
  end
end
