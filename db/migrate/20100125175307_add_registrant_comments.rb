class AddRegistrantComments < ActiveRecord::Migration
  def self.up
    add_column :registrants, :comments, :text, :null => true
  end

  def self.down
    remove_column :registrants, :comments
  end
end
