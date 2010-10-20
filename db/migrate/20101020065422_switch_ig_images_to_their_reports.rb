class SwitchIgImagesToTheirReports < ActiveRecord::Migration
  def self.up
    InterestGroup.paginated_each do |ig|
      ig.report.update_attribute(:image_id, ig.image_id)
    end
    remove_column :interest_groups, :image_id
  end

  def self.down
    add_column :interest_groups, :image_id, :integer
    add_foreign_key :interest_groups, :images
  end
end
