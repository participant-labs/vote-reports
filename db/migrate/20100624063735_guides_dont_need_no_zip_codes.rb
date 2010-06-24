class GuidesDontNeedNoZipCodes < ActiveRecord::Migration
  def self.up
    remove_column :guides, :zip_code, :plus_4
    rename_column :guides, :district_id, :congression_district_id
  end

  def self.down
    add_column :guides, :zip_code_id, :integer
    add_column :guides, :plus_4, :integer
    rename_column :guides, :congression_district_id, :district_id
  end
end
