class CreateAdministrators < ActiveRecord::Migration
  def self.up
    create_table :administrators do |t|
      t.column 'email',       :string,  :limit => 64, :default => '', :null => false
      t.column 'pass',        :string,  :limit => 40, :default => '', :null => false
      t.column 'salt',        :string,  :limit => 10, :default => '', :null => false
			t.column 'created_at',  :datetime,                              :null => false
			t.column 'modified_at', :datetime,                              :null => false
    end
  end

  def self.down
    drop_table :administrators
  end
end
