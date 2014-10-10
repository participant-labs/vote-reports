class CreateInstantPaymentNotifications < ActiveRecord::Migration
  def change
    create_table :amazon_instant_payment_notifications do |t|
      t.json :params
      t.timestamps
    end
  end
end
