class ExistingUserEmailAuthenticationService
  def initialize(auth)
    @auth = auth
  end

  def call
    user = find_user_by_email

    user
  end

  private

  def find_user_by_email
    email = @auth.extra.raw_info.email if account_verified?

    User.find_by_email(email)
  end

  def account_verified?
    @auth.info.verified?
  end
end
