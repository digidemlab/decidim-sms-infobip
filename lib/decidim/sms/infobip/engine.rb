# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module Sms
    module Infobip
      # This is the engine that runs on the public interface of sms-infobip.
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Sms::Infobip

        routes do
          post "deliveries/:id", to: "deliveries#update", as: :delivery
        end

        initializer "sms_infobip.mount_routes" do
          Decidim::Core::Engine.routes do
            mount Decidim::Sms::Infobip::Engine => "/sms/infobip"
          end
        end

        initializer "sms_infobip.configure_gateway", before: :load_config_initializers do
          Decidim.config.sms_gateway_service = "Decidim::Sms::Infobip::Gateway"
        end

        initializer "sms_infobip.webpacker.assets_path" do
          Decidim.register_assets_path File.expand_path("app/packs", root)
        end
      end
    end
  end
end
