# frozen_string_literal: true

module Decidim
  module Sms
    module Infobip
      class RetryFailedDeliveryJob < ApplicationJob
        queue_as :default

        def perform(*params, queued: false)
          Gateway.new(params, queued:).deliver_code
        end
      end
    end
  end
end
