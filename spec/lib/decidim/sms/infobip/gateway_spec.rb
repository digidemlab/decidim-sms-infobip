# frozen_string_literal: true

require "spec_helper"

describe Decidim::Sms::Infobip::Gateway do
  include_context "with Infobip SMS token endpoint"
  include_context "with Infobip Messaging endpoint"

  let(:organization) { create(:organization) }

  shared_examples "working messaging API" do
    let(:gateway) { described_class.new(phone_number, message, organization:) }
    let(:phone_number) { "+358401234567" }
    let(:message) { "Testing message" }

    describe "#deliver_code" do
      subject { gateway.deliver_code }

      it { is_expected.to be(true) }

      it "creates a new delivery" do
        expect { subject }.to change(Decidim::Sms::Infobip::Delivery, :count).by(1)

        delivery = Decidim::Sms::Infobip::Delivery.last
        expect(delivery.to).to eq(phone_number)
        expect(delivery.from).to eq(Rails.application.secrets.infobip[:sender_address])
        expect(delivery.status).to eq("sent")
        expect(delivery.resource_url).to eq(resource_url)
        expect(delivery.callback_data).to match(/[a-zA-Z0-9]{32}/)
      end

      context "with incorrect credentials" do
        let(:auth_token_credentials) { %w(foo bar) }

        it "raises a InfobipAuthenticationError" do
          expect { subject }.to raise_error(Decidim::Sms::Infobip::InfobipAuthenticationError)
        end
      end

      context "with invalid authorization token" do
        let(:authorization_token) { "foobar" }

        it "raises a InfobipServerError" do
          expect { subject }.to raise_error(Decidim::Sms::Infobip::InfobipServerError)
        end
      end

      context "with policy errors" do
        {
          "POL3003" => :server_busy,
          "POL3101" => :invalid_to_number,
          "POL3006" => :destination_whitelist,
          "POL3007" => :destination_blacklist
        }.each do |code, error|
          context "when #{code}" do
            let(:messaging_api_policy_exception) { code }
            let(:gateway_error) { error }

            it "throws a InfobipPolicyError" do
              expect { subject }.to raise_error(Decidim::Sms::Infobip::InfobipPolicyError)

              begin
                subject
              rescue Decidim::Sms::Infobip::InfobipPolicyError => e
                expect(e.error_code).to be(gateway_error)
              end
            end
          end
        end

        context "when unknown" do
          let(:messaging_api_policy_exception) { "POL9999" }

          it "throws a InfobipPolicyError" do
            expect { subject }.to raise_error(Decidim::Sms::Infobip::InfobipPolicyError)

            begin
              subject
            rescue Decidim::Sms::Infobip::InfobipPolicyError => e
              expect(e.error_code).to be(:unknown)
            end
          end
        end
      end
    end
  end

  context "with the sandbox endpoint" do
    let(:api_mode) { "sandbox" }

    context "with default behavior" do
      it_behaves_like "working messaging API"
    end

    context "when the mode is unknown" do
      before do
        infobip_secrets = Rails.application.secrets.infobip
        allow(Rails.application.secrets).to receive(:infobip).and_return(
          infobip_secrets.merge(mode: "foobar")
        )
      end

      it_behaves_like "working messaging API"
    end
  end

  context "with the production endpoint" do
    let(:api_mode) { "production" }

    before do
      allow(Rails.env).to receive(:test?).and_return(false)
    end

    context "with default behavior" do
      it_behaves_like "working messaging API"
    end

    context "when set through the secrrets" do
      before do
        infobip_secrets = Rails.application.secrets.infobip
        allow(Rails.application.secrets).to receive(:infobip).and_return(
          infobip_secrets.merge(mode: api_mode)
        )
      end

      it_behaves_like "working messaging API"
    end
  end
end
