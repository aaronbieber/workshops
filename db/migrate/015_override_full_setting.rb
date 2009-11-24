class OverrideFullSetting < ActiveRecord::Migration
  def self.up
		add_column :workshops, :full, :boolean, { :default => false }
  end

  def self.down
		remove_column :workshops, :full
  end
end
