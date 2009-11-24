class AddWorkshopActive < ActiveRecord::Migration
  def self.up
		add_column :workshops, :active, :boolean, { :default => false }
  end

  def self.down
		remove_column :workshops, :active
  end
end
