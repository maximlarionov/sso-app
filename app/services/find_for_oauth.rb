class FindForOauth
  TEMP_EMAIL_PREFIX = "change@me"

  def initialize(auth, signed_in_resource = nil)
    @auth = auth
    @signed_in_resource = signed_in_resource
  end

  def call
    find_user_by_identity
  end

  private

  def identity
    Identity.find_for_oauth(@auth)
  end

  def find_user_by_identity
    @signed_in_resource || identity.user || find_user_by_email
  end

  def find_user_by_email
    email = @auth.extra.raw_info.email if email_verified?

    user = User.find_by_email(email) || new_user_registration

    connect_accounts(identity, user)

    user
  end

  def new_user_registration
    user = User.new(
      full_name: @auth.extra.raw_info.name,
      email: @auth.extra.raw_info.email.presence || "#{TEMP_EMAIL_PREFIX}-#{@auth.uid}-#{@auth.provider}.com",
      password: Devise.friendly_token[0, 20]
    )
    user.skip_confirmation_notification!
    user.save!

    user
  end

  def connect_accounts(identity, user)
    return false unless identity.user != user

    identity.user = user
    identity.save!
  end

  def email_verified?
    @auth.info.verified?
  end
end
