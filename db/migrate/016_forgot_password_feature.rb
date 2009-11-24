class ForgotPasswordFeature < ActiveRecord::Migration
  def self.up
    add_column :students, :new_password, :string, { :limit => 32, :null => true }
    add_column :students, :new_password_date, :date, { :null => true }
  end

  def self.down
    remove_column :students, :new_password
    remove_column :students, :new_password_date
  end
end
