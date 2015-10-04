class FindForOauth
  def initialize(user, auth, signed_in_resource = nil)
    @user = user
    @auth = auth
    @signed_in_resource = signed_in_resource
  end

  def find_for_oauth
    find_user_by_identity
  end

  private

  def find_user_by_identity
    identity = Identity.find_for_oauth(@auth)

    user = @signed_in_resource ? @signed_in_resource : identity.user

    user || find_user_by_email
  end

  def find_user_by_email
    email = @auth.extra.raw_info.email

    user = User.find_by_email(email)

    new_user_registration if user.nil?

    associate_user_with(identity)
  end

  def new_user_registration
    user = User.new(
      full_name: @auth.extra.raw_info.name,
      email: @auth.extra.raw_info.email.presence || "#{TEMP_EMAIL_PREFIX}-#{@auth.uid}-#{@auth.provider}.com",
      password: Devise.friendly_token[0, 20]
    )
    user.skip_confirmation_notification!
    user.save!
  end

  def associate_user_with(identity)
    return false unless identity.user != @user

    identity.user = @user
    identity.save!
  end
end
