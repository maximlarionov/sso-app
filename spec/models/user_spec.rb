require "rails_helper"

describe User do
  let(:user) { create(:user) }

  describe "validations" do
    it { is_expected.to validate_presence_of :full_name }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to have_many :identities }

    it "validates format of email on update" do
      expect(user.update(email: "change@me-facebook.com")).to be_falsey
      expect(user.update(email: "such-email@doge-post.com")).to be_truthy
    end
  end

  describe "#to_s" do
    it "is eq full name" do
      expect(user.to_s).to eq user.full_name
    end
  end

  describe "#full_name_with_email" do
    subject { user.full_name_with_email }

    context "when email is verified" do
      before { allow(user).to receive(:email_verified).and_return(true) }

      it { is_expected.to eq "#{user.full_name} (#{user.email})" }
    end

    context "when email is not verified" do
      before { user.update_attribute(:email, "change@me-facebook.com") }

      it { is_expected.to eq user.full_name }
    end
  end

  describe "#email_verified?" do
    subject { user }

    context "when not verified" do
      before { user.update_attribute(:email, "change@me-facebook.com") }

      its(:email_verified?) { is_expected.to be_falsey }
      its(:email) { is_expected.to match User::TEMP_EMAIL_REGEX }
    end

    context "when verified" do
      before { user.update_attribute(:email, "such-email@doge-post.com") }

      it(:email_verified?) { is_expected.to be_truthy }
      its(:email) { is_expected.not_to match User::TEMP_EMAIL_REGEX }
    end
  end
end
