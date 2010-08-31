class GuidesDontReferenceCongressionalDistricts < ActiveRecord::Migration
  def self.up
    remove_column :guides, :congressional_district_id
  end

  def self.down
    add_column :guides, :congressional_district_id, :integer
  end
end
