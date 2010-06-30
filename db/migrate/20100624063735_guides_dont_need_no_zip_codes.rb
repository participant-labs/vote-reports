class GuidesDontNeedNoZipCodes < ActiveRecord::Migration
  def self.up
    remove_column :guides, :zip_code, :plus_4
  end

  def self.down
    add_column :guides, :zip_code_id, :integer
    add_column :guides, :plus_4, :integer
  end
end
