class AddVoteSmartPhotoToPoliticians < ActiveRecord::Migration
  def self.up
    add_column :politicians, :vote_smart_photo_url, :string
  end

  def self.down
    remove_column :politicians, :vote_smart_photo_url, :string
  end
end
