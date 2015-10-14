require "rails_helper"

describe AuthVerificationPolicy do
  include_context :auth_hashie
  let(:user) { double(User, identities: [identity]) }
  let(:user_signed_in) { true }
  let(:identity) { double(Identity, provider: "github") }

  let(:policy) { AuthVerificationPolicy.new(auth_hashie, user, user_signed_in) }

  describe "#facebook" do
    subject { policy.facebook }

    its(:policy) { is_expected.to be_truthy }

    context "when account isn't verified" do
      include_context :invalid_auth_hashie

      its(:policy) { is_expected.to be_falsey }
    end
  end

  describe "#github" do
    subject { policy.github }

    its(:policy) { is_expected.to be_truthy }

    context "when account isn't verified" do
      include_context :invalid_auth_hashie

      its(:policy) { is_expected.to be_truthy }
    end

    context "when user is not signed in, but has been already authenticated with github" do
      let(:user_signed_in) { false }

      its(:policy) { is_expected.to be_truthy }
    end

    context "when user is signed in, but not authenticated with github" do
      let(:user) { double(User, identities: []) }

      its(:policy) { is_expected.to be_truthy }
    end

    context "when user is not signed in, neither authenticated with github" do
      let(:user) { double(User, identities: []) }
      let(:user_signed_in) { false }

      its(:policy) { is_expected.to be_falsey }
    end
  end

  describe "#google_oauth2" do
    subject { policy.google_oauth2 }

    its(:policy) { is_expected.to be_truthy }

    context "when account isn't verified" do
      include_context :invalid_auth_hashie

      its(:policy) { is_expected.to be_falsey }
    end
  end
end
