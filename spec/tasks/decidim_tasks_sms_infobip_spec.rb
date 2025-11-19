# frozen_string_literal: true

require "spec_helper"

describe "Executing Decidim SMS Infobip tasks" do
  include_context "with Infobip SMS token endpoint"
  include_context "with Infobip Messaging endpoint"

  let(:organization) { create(:organization) }
  let(:api_mode) { "sandbox" }

  describe "rake decidim:sms_infobip:test", type: :task do
    let(:phone_number) { "+358401234567" }

    context "when executing task" do
      it "shows shows the correct log messages" do
        Rake::Task[:"decidim:sms_infobip:test"].invoke(organization.id, phone_number)

        expect($stdout.string).to eq("The test message has been successfully sent to: #{phone_number}\n")
      end
    end
  end
end
