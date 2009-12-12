class DropTermTypeAsTheyreOnSeparateTables < ActiveRecord::Migration
  def self.up
    remove_column :senate_terms, :type
    remove_column :representative_terms, :type
  end

  def self.down
    add_column :senate_terms, :type, :string
    add_column :representative_terms, :type, :string
  end
end
