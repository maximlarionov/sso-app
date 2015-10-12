require "rails_helper"

feature "Sign In with social account" do
  let!(:user) { create :user, :confirmed, :from_auth_hashie }

  def sign_in_with_facebook
    visit new_user_session_path

    click_link "Sign in with Facebook"
  end

  include_context :stub_omniauth

  scenario "user signs in directly to main page" do
    sign_in_with_facebook

    expect(page).to have_content("Home")
    expect(page).to have_content(user.full_name)
    expect(page).to have_content(user.email)
  end

  context "when social network account is not verified" do
    include_context :stub_not_verified_omniauth

    scenario "is notified with notice" do
      sign_in_with_facebook

      expect(page).to have_content("Your Facebook account is not verified")
      expect(page).not_to have_content(user.full_name)
      expect(page).not_to have_content(user.email)
    end
  end

  context "when user account is not confirmed" do
    let!(:user) { create :user, :not_confirmed, :from_auth_hashie }

    scenario "user is offered to create new account" do
      sign_in_with_facebook

      expect(page).to have_content("You have to confirm your email address before continuing")
      expect(page).to have_field("Enter your email address")
      expect(page).to have_field("Password")
      expect(page).to have_button("Sign in")
    end
  end
end
