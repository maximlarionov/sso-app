require "rails_helper"

describe NewUserRegistrationService do
  include_context :auth_hashie

  describe "#call" do
    subject(:service_call) { described_class.new(auth_hashie).call }

    it "creates new user" do
      expect { service_call }.to change { User.count }.from(0).to(1)
    end

    its(:email) { is_expected.to eq "joe@bloggs.com" }
    its(:full_name) { is_expected.to eq "Joe Bloggs" }
  end
end
