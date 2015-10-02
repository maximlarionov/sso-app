module FinishAuthentication
  extend ActiveSupport::Concern

  def finish_signup
    return false unless request.patch? && user.valid?

    user.update(user_params) ? sign_in_user : render_errors
  end

  def required_params
    params[:user] && params[:user][:email] && params[:user][:password]
  end

  private

  def sign_in_user
    user.skip_reconfirmation!
    sign_in(user, bypass: true)
    redirect_to root_path, notice: "Please confirm your email from your mailbox."
  end

  def render_errors
    respond_to do |format|
      format.html { render action: "finish_signup", user: user }
      format.json { render json: user.errors, status: :unprocessable_entity }
    end
  end
end
