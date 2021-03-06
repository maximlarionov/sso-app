ENV["RAILS_ENV"] ||= "test"

require "spec_helper"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "shoulda/matchers"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
OmniAuth.config.test_mode = true

RSpec.configure do |config|
  config.before(:suite) { FactoryGirl.reload }

  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  config.include Devise::TestHelpers, type: :controller
end
