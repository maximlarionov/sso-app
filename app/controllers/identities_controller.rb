class IdentitiesController < ActionController::Base
  before_action :authenticate_user!

  expose(:user) { identity.user }
  expose(:identity) { Identity.find_by_provider(params[:provider]) }

  def destroy
    identity.destroy
    redirect_to edit_user_registration_path, notice: "Yours #{params[:provider].titleize} account unlinked."
  end
end
