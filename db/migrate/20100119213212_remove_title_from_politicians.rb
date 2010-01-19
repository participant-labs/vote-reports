class RemoveTitleFromPoliticians < ActiveRecord::Migration
  def self.up
    remove_column :politicians, :title
  end

  def self.down
    add_column :politicians, :title, :string
  end
end
