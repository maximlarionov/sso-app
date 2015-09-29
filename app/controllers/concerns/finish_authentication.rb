module FinishAuthentication
  extend ActiveSupport::Concern

  def finish_signup
    if request.patch? && user.valid?
      if user.update(user_params)
        user.skip_reconfirmation!
        sign_in(user, :bypass => true)
        redirect_to root_path, notice: 'Please confirm your email from your mailbox.'
      else
        respond_to do |format|
          format.html { render action: 'finish_signup', user: user }
          format.json { render json: user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def required_params
    params[:user] && params[:user][:email] && params[:user][:password]
  end
end
