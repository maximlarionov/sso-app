require "rails_helper"

feature "Update Account" do
  let(:user) { create :user, :confirmed }
  let(:auth) { create :auth_hashie }

  background do
    user.identities.find_for_oauth(auth)

    login_as user
    visit edit_user_registration_path(user)
  end

  scenario "User updates account with valid data" do
    fill_form(:user, full_name: "New Name", current_password: user.password)
    click_on "Update"

    expect(page).to have_content("New Name")
  end

  scenario "User updates account with invalid password" do
    fill_form(:user, full_name: "New Name", current_password: "wrong")
    click_on "Update"

    expect(page).to have_content("is invalid")
  end

  describe "oauth actions" do
    include_context :stub_omniauth

    scenario "User unlinks and links back social account from profile" do
      click_link "Successfully authorized via Facebook. Unautorize?"
      expect(page).to have_link("Authorize via Facebook")
      click_link "Authorize via Facebook"

      expect(page).to have_content("Successfully authenticated from Facebook account.")
    end
  end
end
