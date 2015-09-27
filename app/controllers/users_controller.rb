class UsersController < ApplicationController
  expose(:user)

  def update
    respond_to do |format|
      if user.update(user_params)
        sign_in(user == current_user ? user : current_user, :bypass => true)
        format.html { redirect_to user, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end

  def finish_signup
    if request.patch? && params[:user] && params[:user][:email] && params[:user][:password]
      if user.update(user_params)
        user.skip_reconfirmation!
        sign_in(user, :bypass => true)
        redirect_to root_path, notice: 'Your profile was successfully updated.'
      else
        respond_to do |format|
          format.html { render action: 'finish_signup', user: user }
          format.json { render json: user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  private

  def user_params
    accessible = [ :full_name, :email, :password ] # extend with your own params
    accessible << [ :password_confirmation ] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end
end
