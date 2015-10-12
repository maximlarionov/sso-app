require "rails_helper"

shared_context :stub_omniauth do
  background do
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '123545',
      info: {
        email: "joe@bloggs.com",
        name: "Joe Bloggs",
        verified: true
      },
      extra: {
        raw_info: {
          email: "joe@bloggs.com",
          name: "Joe Bloggs",
          verified: true
        }
      }
    })
  end
end

shared_context :stub_not_verified_omniauth do
  background do
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '123545',
      info: {
        email: "joe@bloggs.com",
        name: "Joe Bloggs",
        verified: false
      },
      extra: {
        raw_info: {
          email: "joe@bloggs.com",
          name: "Joe Bloggs",
          verified: false
        }
      }
    })
  end
end
