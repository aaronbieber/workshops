class AddPaymentDefVals < ActiveRecord::Migration
  def self.up
		change_column :registrants, :payment_submitted, :boolean, { :default => 0 }
		change_column :registrants, :payment_received, :boolean, { :default => 0 }
  end

  def self.down
  end
end
