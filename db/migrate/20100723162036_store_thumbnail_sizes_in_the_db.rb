class StoreThumbnailSizesInTheDb < ActiveRecord::Migration
  def self.up
    change_table 'images' do |t|
      t.string :thumbnail_tiny_size
      t.string :thumbnail_normal_size
      t.string :thumbnail_header_size
      t.string :thumbnail_large_size
    end
  end

  def self.down
    remove_columns 'images', :thumbnail_tiny_size, :thumbnail_normal_size, :thumbnail_header_size, :thumbnail_large_size
  end
end
