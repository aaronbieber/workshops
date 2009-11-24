class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.column "title",       :string,    :limit => 128,  :default => "", :null => false
      t.column "name",        :string,    :limit => 128,  :default => "", :null => false
      t.column "text",        :text,                      :default => "", :null => true
			t.column "created_at",  :datetime,                                  :null => false
			t.column "modified_at", :datetime,                                  :null => true
    end
  end

  def self.down
    drop_table :pages
  end
end
