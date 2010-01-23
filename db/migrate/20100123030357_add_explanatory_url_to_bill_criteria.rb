class AddExplanatoryUrlToBillCriteria < ActiveRecord::Migration
  def self.up
    add_column :bill_criteria, :explanatory_url, :string
  end

  def self.down
    remove_column :bill_criteria, :explanatory_url
  end
end
