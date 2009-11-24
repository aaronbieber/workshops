class AddWorkshopAncestor < ActiveRecord::Migration
  def self.up
    add_column :workshops,  :ancestor_id, :integer, :null => true
  end

  def self.down
    remove_column :workshops, :ancestor_id
  end
end
