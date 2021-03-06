class UsersController < ApplicationController
  respond_to :html
  expose(:user, attributes: :user_params)

  before_action :authenticate_user!, only: :home

  def home
  end

  def finish_signup
    return false unless request.patch? # don't try to update user with get request, lol

    user.update_attributes(user_params) ? sign_in_user : render_errors
  end

  private

  def sign_in_user
    user.skip_reconfirmation!
    confirm_user
    sign_in(user, bypass: true)
    redirect_to root_path, notice: "Welcome!"
  end

  def render_errors
    respond_to do |format|
      format.html { render action: "finish_signup", user: user }
      format.json { render json: user.errors, status: :unprocessable_entity }
    end
  end

  def confirm_user
    user.update_attribute(:confirmed_at, Time.zone.now)
  end

  def user_params
    params.require(:user).permit %i(full_name email password password_confirmation current_password)
  end
end
