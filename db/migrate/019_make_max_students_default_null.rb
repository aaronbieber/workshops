class MakeMaxStudentsDefaultNull < ActiveRecord::Migration
  def self.up
    change_column :workshops, :max_students, :integer, :null => true, :default => nil
  end

  def self.down
    change_column :workshops, :max_students, :integer, :null => false, :default => 0
  end
end
