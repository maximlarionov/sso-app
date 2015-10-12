# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :auth_hashie, class: OpenStruct do
    provider "facebook"
    uid "1234567"

    info do
      OpenStruct.new(
        email: "joe@bloggs.com",
        name: "Joe Bloggs",
        verified: true
      )
    end

    extra do
      OpenStruct.new(
        raw_info: OpenStruct.new(
          name: "Joe Bloggs",
          email: "joe@bloggs.com",
          verified: true
        )
      )
    end
  end
end
