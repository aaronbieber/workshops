class AddStudentPassword < ActiveRecord::Migration
  def self.up
		add_column :students, :password, :string, :limit => 32
  end

  def self.down
		remove_column :students, :password
  end
end
