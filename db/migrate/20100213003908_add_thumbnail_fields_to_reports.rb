class AddThumbnailFieldsToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :thumbnail_file_name, :string
    add_column :reports, :thumbnail_content_type, :string
    add_column :reports, :thumbnail_file_size, :string
  end

  def self.down
    remove_column :reports, :thumbnail_file_name
    remove_column :reports, :thumbnail_content_type
    remove_column :reports, :thumbnail_file_size
  end
end
