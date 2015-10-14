require "rails_helper"

describe ExistingUserIdentityAuthenticationService do
  include_context :auth_hashie

  let(:user) { double(User, identities: [identity]) }
  let(:identity) { double(Identity, provider: "github", user: user) }

  subject { described_class.new(auth_hashie, user).call }

  describe "#call" do
    context "when identity is missing" do
      let(:user) { double(User, identities: []) }
      let(:identity) { nil }

      it { is_expected.to eq user }
    end

    context "when user is missing" do
      let(:user) { nil }

      it { is_expected.to be_falsey }
    end

    context "when user and identity are missing" do
      let(:user) { nil }
      let(:identity) { nil }

      it { is_expected.to be_falsey }
    end
  end
end
