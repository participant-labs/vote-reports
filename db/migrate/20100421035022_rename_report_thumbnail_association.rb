class RenameReportThumbnailAssociation < ActiveRecord::Migration
  def self.up
    rename_column :reports, :thumbnail_id, :image_id
  end

  def self.down
    rename_column :reports, :image_id, :thumbnail_id
  end
end
