require "rails_helper"

describe IdentitiesController do
  let(:user) { create(:user) }
  let(:identity) { create(:identity, user: user) }

  describe "#destroy" do
    it "destroys identity" do
      delete :destroy, id: user.id, provider: identity.provider
    end
  end
end
