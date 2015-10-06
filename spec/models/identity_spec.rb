require "rails_helper"

describe Identity do
  it { is_expected.to belong_to :user }
  it { is_expected.to validate_presence_of :uid }
  it { is_expected.to validate_presence_of :provider }
  it { is_expected.to validate_uniqueness_of :provider }

  describe ".find_for_oauth" do
    let(:user) { create(:user) }
    let(:auth) { double(uid: 123, provider: "facebook") }

    subject(:find_for_oauth) { Identity.find_for_oauth(auth) }

    context "when Identity exists" do
      let!(:identity) { create(:identity, uid: 123, provider: "facebook", user: user) }

      it { is_expected.to eq identity }
    end

    context "when Identity does not exist" do
      let(:identity) { build(:identity, uid: 321, provider: "twitter") }
      before { allow(Identity).to receive(:new).and_return(identity) }

      it { is_expected.to eq identity }
      its(:uid) { is_expected.to eq "321" }
      its(:provider) { is_expected.to eq "twitter" }
    end
  end
end
