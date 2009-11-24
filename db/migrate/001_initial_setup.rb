class InitialSetup < ActiveRecord::Migration
  def self.up
		create_table "students", :force => true do |t|
			t.column "first_name",  :string,   :limit => 64,  :default => "", :null => false
			t.column "last_name",   :string,   :limit => 64,  :default => "", :null => false
			t.column "email",       :string,   :limit => 128, :default => "", :null => false
			t.column "address1",    :string,   :limit => 128, :default => "", :null => false
			t.column "address2",    :string,   :limit => 128
			t.column "city",        :string,   :limit => 128, :default => "", :null => false
			t.column "state",       :string,   :limit => 2,   :default => "", :null => false
			t.column "zip",         :string,   :limit => 9,   :default => "", :null => false
			t.column "phone",       :string,   :limit => 10
			t.column "ext",         :string,   :limit => 10
			t.column "created_at",  :datetime,                                :null => false
			t.column "modified_at", :datetime,                                :null => false
		end

		create_table "students_workshops", :force => true do |t|
			t.column "student_id",  :integer, :default => 0, :null => false
			t.column "workshop_id", :integer, :default => 0, :null => false
		end

		create_table "workshops", :force => true do |t|
			t.column "name",         :string,   :limit => 128, :default => "",  :null => false
			t.column "short_name",   :string,   :limit => 128, :default => "",  :null => false
			t.column "description",  :text,                    :default => "",  :null => false
			t.column "cutoff_date",  :date,                                     :null => false
			t.column "start_date",   :date,                                     :null => false
			t.column "end_date",     :date,                                     :null => false
			t.column "max_students", :integer,                 :default => 0,   :null => false
			t.column "cost",         :float,                   :default => 0.0, :null => false
			t.column "created_at",   :datetime,                                 :null => false
			t.column "modified_at",  :datetime,                                 :null => false
		end
  end

  def self.down
		drop_table "workshops"
		drop_table "students_workshops"
		drop_table "students"
  end
end
