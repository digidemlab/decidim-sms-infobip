# frozen_string_literal: true

class CreateDecidimSmsInfobipDeliveries < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_sms_infobip_deliveries do |t|
      t.string :from
      t.string :to
      t.string :status
      t.string :resource_url
      t.string :callback_data

      t.timestamps
    end
  end
end
