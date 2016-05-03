require "rails_helper"

describe OauthOrganizer do
  include_context :auth_hashie

  let(:user) { create(:user, confirmed_at: Time.zone.now, email: "joe@bloggs.com") }

  subject(:oauth_organizer) { OauthOrganizer.new(auth_hashie, user) }

  describe "#call" do
    context "when user is present" do
      its(:call) { is_expected.to eq user }
    end

    context "when there is no user" do
      before { allow(oauth_organizer).to receive(:build_response).and_return(nil) }

      it "raises an error" do
        expect { oauth_organizer.call }.to raise_error(OauthOrganizer::OauthError)
      end
    end

    context "when auth hash isn't verified" do
      before do
        allow_any_instance_of(AuthVerificationPolicy).to receive(auth_hashie.provider).and_return(false)
      end

      it "raises an error" do
        expect { oauth_organizer.call }.to raise_error(OauthOrganizer::OauthError)
      end
    end

    context "when connecting social account to signed in user" do
      it "calls ExistingUserIdentityAuthenticationService" do
        expect_any_instance_of(ExistingUserIdentityAuthenticationService).to receive(:call).and_return(user)

        oauth_organizer.call
      end
    end

    context "when signing in with already connected social account" do
      let!(:identity) { user.identities.find_for_oauth(auth_hashie) }

      it "calls ExistingUserIdentityAuthenticationService" do
        expect_any_instance_of(ExistingUserIdentityAuthenticationService).to receive(:call).and_return(user)

        oauth_organizer.call
      end
    end
  end
end
