class DropInOfficeColumnFromPoliticians < ActiveRecord::Migration
  def self.up
    remove_column :politicians, :in_office
  end

  def self.down
    add_column :politicians, :in_office, :string
  end
end
