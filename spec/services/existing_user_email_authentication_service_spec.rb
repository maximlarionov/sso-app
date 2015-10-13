require "rails_helper"

describe ExistingUserEmailAuthenticationService do
  include_context :auth_hashie
  let!(:user) { create(:user, :from_auth_hashie) }

  describe "#call" do
    subject { described_class.new(auth_hashie).call }

    it { is_expected.to eq user }

    context "when user with email from auth_hashie does not exist" do
      let!(:user) { create(:user, email: "another@email.com") }

      it { is_expected.to be_nil }
    end
  end
end
