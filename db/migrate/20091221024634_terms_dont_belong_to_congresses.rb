class TermsDontBelongToCongresses < ActiveRecord::Migration
  def self.up
    remove_column :representative_terms, :congress_id
    remove_column :senate_terms, :congress_id
  end

  def self.down
    add_column :representative_terms, :congress_id, :integer
    add_column :senate_terms, :congress_id, :integer
  end
end
