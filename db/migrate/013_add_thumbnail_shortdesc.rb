class AddThumbnailShortdesc < ActiveRecord::Migration
  def self.up
		add_column :workshops, :thumbnail, :string, { :limit => 255, :null => true }
		add_column :workshops, :short_desc, :text, { :null => true }
  end

  def self.down
		remove_column :workshops, :thumbnail
		remove_column :workshops, :short_desc
  end
end
