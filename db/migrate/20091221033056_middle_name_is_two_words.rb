class MiddleNameIsTwoWords < ActiveRecord::Migration
  def self.up
    rename_column :politicians, :middlename, :middle_name
  end

  def self.down
    rename_column :politicians, :middle_name, :middlename
  end
end
