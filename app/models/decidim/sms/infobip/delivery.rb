# frozen_string_literal: true

module Decidim
  module Sms
    module Infobip
      # The data store for a Delivery status of messages being sent to the users
      class Delivery < Infobip::ApplicationRecord
        before_create :generate_callback_data

        def generate_callback_data
          loop do
            self.callback_data = generate_digest
            break if ::Decidim::Sms::Infobip::Delivery.find_by(callback_data:).blank?
          end
        end

        private

        def generate_digest
          characters = ("0".."9").to_a + ("A".."Z").to_a + ("a".."z").to_a
          characters.sample(32).join
        end
      end
    end
  end
end
