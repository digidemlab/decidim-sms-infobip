::Infobip::Sms::Request.configure do |c|
  c.identifier           = ENV.fetch("INFOBIP_APP_IDENTIFIER")
  c.base_url             = ENV.fetch("INFOBIP_BASEURL")
  c.api_key              = ENV.fetch("INFOBIP_APIKEY")
  c.sms_identifier       = ENV.fetch("INFOBIP_SENDERID")
  c.sms_endpoint         = nil
  c.sms_reports_endpoint = nil
end
