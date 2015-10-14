require "rails_helper"

describe ProviderTrustPolicy do
  include_context :auth_hashie
  let(:identity) { double(Identity, provider: "github") }

  subject(:policy) { described_class.new(auth_hashie, user).trustworthy? }

  before do
    auth_hashie.provider = "github"
  end

  describe "#github" do
    context "when user has github identity" do
      let(:user) { double(User, identities: [identity]) }

      it { is_expected.to be_truthy }
    end

    context "when there is no user/cannot sign_in or sign_up from scratch" do
      let(:user) { nil }

      it { is_expected.to be_falsey }
    end

    context "when user does not have github identity" do
      let(:user) { double(User, identities: []) }

      it { is_expected.to be_falsey }
    end
  end
end
