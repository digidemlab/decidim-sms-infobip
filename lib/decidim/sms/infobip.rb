# frozen_string_literal: true

require "infobip/sms"

require "decidim/sms/infobip/engine"

module Decidim
  module Sms
    # This namespace holds the logic for Infobip SMS integration.
    module Infobip
      autoload :Gateway, "decidim/sms/infobip/gateway"
      autoload :Http, "decidim/sms/infobip/http"
      autoload :TokenManager, "decidim/sms/infobip/token_manager"

      include ActiveSupport::Configurable

      # Default configuration wait interval before retry sending a queued sms that was
      # failed due to a busy server.
      config_accessor :sms_retry_delay do
        10
      end
    end
  end
end
