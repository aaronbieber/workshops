class AddPaymentColumns < ActiveRecord::Migration
  def self.up
		add_column :registrants, :payment_submitted, :boolean
		add_column :registrants, :payment_received, :boolean
  end

  def self.down
		remove_column :registrants, :payment_submitted
		remove_column :registrants, :payment_received
  end
end
