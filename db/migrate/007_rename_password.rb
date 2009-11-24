class RenamePassword < ActiveRecord::Migration
  def self.up
		rename_column :students, :password, :pass
  end

  def self.down
		rename_column :students, :pass, :password
  end
end
