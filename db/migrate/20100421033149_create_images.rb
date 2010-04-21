class CreateImages < ActiveRecord::Migration
  def self.up
    rename_table :thumbnails, :images
  end

  def self.down
    rename_table :images, :thumbnails
  end
end
