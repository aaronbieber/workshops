class AddStudentSalt < ActiveRecord::Migration
  def self.up
		add_column :students, :salt, :string, :limit => 10
  end

  def self.down
		remove_column :students, :salt
  end
end
