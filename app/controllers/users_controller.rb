class UsersController < ApplicationController
  include FinishAuthentication

  respond_to :html
  expose(:user, attributes: :user_params)

  def update
    sign_in_with_user if user.update
    respond_with user
  end

  def destroy
    user.destroy
    redirect_to root_url
  end

  def confirm_email
    user.resend_confirmation_instructions
    redirect_to edit_user_registration_path
  end

  private

  def user_params
    accessible = %i(full_name email password)
    accessible << %i(password_confirmation) unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end

  def sign_in_with_user
    user ||= current_user

    sign_in(user, bypass: true)
  end
end
