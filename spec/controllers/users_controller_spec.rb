require "rails_helper"

describe UsersController do
  describe "#home" do
    let(:user) { create(:user) }

    it "blocks unauthenticated access" do
      get :home

      expect(response).to redirect_to(new_user_session_path)
    end

    it "allows authenticated access" do
      sign_in user

      get :home

      expect(response).to be_success
      expect(response).to render_template("home")
    end
  end

  describe "#finish_signup" do
    let(:user) { create(:user, email: "old_email@mail.com") }

    it "renders page on :get" do
      get :finish_signup, id: user.id

      expect(response).to be_success
      expect(response).to render_template("finish_signup")
      expect(@controller.finish_signup).to be_falsey
    end
  end
end
