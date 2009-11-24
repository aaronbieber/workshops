class ChangePaymentCols < ActiveRecord::Migration
  def self.up
    change_column :registrants, :payment_submitted, :date, :null => true
    change_column :registrants, :payment_received, :date, :null => true
  end

  def self.down
    change_column :registrants, :payment_submitted, :boolean, { :default => 0 }
    change_column :registrants, :payment_received, :boolean, { :default => 0 }
  end
end
