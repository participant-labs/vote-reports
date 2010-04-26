class AllowNullDistrictNumberAsUnknown < ActiveRecord::Migration
  def self.up
    change_column :districts, :district, :integer, :null => true
  end

  def self.down
    change_column :districts, :district, :integer, :null => false
  end
end
