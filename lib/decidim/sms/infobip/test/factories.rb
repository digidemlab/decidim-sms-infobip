# frozen_string_literal: true

module Decidim
  module Sms
    module Infobip
      module Faker
        # Characters 0-9 (48..57), A-Z (65..90) and a-z (97..122)
        def self.callback_data
          [(48..57), (65..90), (97..122)].map { |r| r.map(&:chr) }.flatten.sample(32).join
        end
      end
    end
  end
end

FactoryBot.define do
  factory :infobip_sms_delivery, class: "Decidim::Sms::Infobip::Delivery" do
    from { Faker::PhoneNumber.cell_phone_in_e164 }
    to { Faker::PhoneNumber.cell_phone_in_e164 }
    status { "initiated" }
    resource_url { "https://api.opaali.infobip.fi/production/messaging/v1/outbound/tel%3A%2B358000000000/requests/nnn" }
    callback_data { Decidim::Sms::Infobip::Faker.callback_data }

    trait :sent do
      status { "sent" }
    end
  end

  factory :infobip_sms_token, class: "Decidim::Sms::Infobip::Token" do
    access_token { "abcdef1234567890" }
    issued_at { Time.zone.now }
    expires_at { issued_at + 9.minutes }
  end
end
