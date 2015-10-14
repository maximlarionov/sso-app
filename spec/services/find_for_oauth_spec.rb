require "rails_helper"

describe FindForOauth do
  include_context :auth_hashie
  let(:find_for_oauth) { FindForOauth.new(auth_hashie, signed_in_resource) }
  let(:signed_in_resource) { create(:user, confirmed_at: Time.zone.now, email: "old@email.mail") }

  describe "#call" do
    subject(:user_from_response) { find_for_oauth.call }

    context "when connecting social account to signed in user" do
      let!(:identity) { create(:identity, uid: "2233311", provider: "twitter", user: signed_in_resource) }

      it { is_expected.to eq signed_in_resource }
    end

    context "when authenticating existing user with social account" do
      let!(:user) { create(:user, email: "joe@bloggs.com") }
      let(:signed_in_resource) { nil }

      it "calls ExistingUserEmailAuthenticationService" do
        expect_any_instance_of(ExistingUserEmailAuthenticationService).to receive(:call).and_return(user)

        find_for_oauth.call
      end
    end

    context "when authenticating new user with social account" do
      let(:signed_in_resource) { nil }

      it "calls NewUserRegistrationService" do
        expect_any_instance_of(NewUserRegistrationService).to receive(:call)

        find_for_oauth.call
      end
    end
  end
end
