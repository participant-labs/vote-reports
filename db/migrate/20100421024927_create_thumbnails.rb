class CreateThumbnails < ActiveRecord::Migration
  def self.up
    create_table :thumbnails do |t|
      t.string :thumbnail_file_name, :null => false
      t.string :thumbnail_content_type, :null => false
      t.integer :thumbnail_file_size, :null => false
      t.datetime :thumbnail_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :thumbnails
  end
end
