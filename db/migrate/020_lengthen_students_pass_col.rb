class LengthenStudentsPassCol < ActiveRecord::Migration
  def self.up
    change_column :students, :pass, :string, :limit => 40, :null => false
  end

  def self.down
    change_column :students, :pass, :string, :limit => 32, :null => false
  end
end
