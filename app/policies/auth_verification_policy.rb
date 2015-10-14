class AuthVerificationPolicy
  attr_reader :auth, :user, :user_signed_in

  def initialize(auth, user, user_signed_in = nil)
    @auth = auth
    @user = user
    @user_signed_in = user_signed_in
  end

  def facebook
    policy = auth.info.verified || auth.extra.raw_info.verified

    OpenStruct.new(policy: policy, notice: notice)
  end

  def twitter
    policy = auth.extra.raw_info.verified

    OpenStruct.new(policy: policy, notice: notice)
  end

  # since github account does not have verified key in auth hash - we won't allow to sign in with
  # github accounts unless it has been already attached from edit page

  def github
    policy = user_signed_in || user.identities.map(&:provider).include?("github")
    notice = "#{auth.provider.titleize} account cannot be used from sign in page.\n
              Please authenticate your #{auth.provider.titleize} account from your profile."

    OpenStruct.new(policy: policy, notice: notice)
  end

  def google_oauth2
    policy = auth.extra.raw_info.email_verified

    OpenStruct.new(policy: policy, notice: notice)
  end

  def notice
    "Your #{auth.provider.titleize} account is not verified."
  end
end
