class MakeCostDefaultNull < ActiveRecord::Migration
  def self.up
    change_column :workshops, :cost, :float, :null => true, :default => nil
  end

  def self.down
    change_column :workshops, :cost, :float, :null => false, :default => 0
  end
end
