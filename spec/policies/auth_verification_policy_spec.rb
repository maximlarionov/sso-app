require "rails_helper"

describe AuthVerificationPolicy do
  include_context :auth_hashie
  let(:user) { double(User, identities: [identity]) }
  let(:user_signed_in) { true }
  let(:identity) { double(Identity, provider: "github") }

  let(:policy) { AuthVerificationPolicy.new(auth_hashie) }

  describe "#facebook" do
    subject { policy.facebook }

    it { is_expected.to be_truthy }

    context "when account isn't verified" do
      include_context :invalid_auth_hashie

      it { is_expected.to be_falsey }
    end
  end

  describe "#github" do
    subject { policy.github }

    it { is_expected.to be_truthy }

    context "when account isn't verified" do
      include_context :invalid_github_auth_hashie

      it { is_expected.to be_falsey }
    end
  end

  describe "#google_oauth2" do
    subject { policy.google_oauth2 }

    it { is_expected.to be_truthy }

    context "when account isn't verified" do
      include_context :invalid_auth_hashie

      it { is_expected.to be_falsey }
    end
  end
end
