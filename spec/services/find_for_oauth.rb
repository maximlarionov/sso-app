require "spec_helper"

describe FindForOauth do
  include_context :auth_response

  let(:find_for_oauth) { described_class.new(auth, signed_in_resource) }
end
