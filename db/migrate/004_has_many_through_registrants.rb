class HasManyThroughRegistrants < ActiveRecord::Migration
  def self.up
    drop_table(:students_workshops)
    create_table :registrants do |t|
      t.column :student_id,   :integer
      t.column :workshop_id,  :integer
    end
  end

  def self.down
    drop_table(:registrants)
    create_table :students_workshops do |t|
      t.column :student_id,   :integer
      t.column :workshop_id,  :integer
    end
  end
end
