class DropPartyFromPoliticianTermsAreBetter < ActiveRecord::Migration
  def self.up
    remove_column :politicians, :party
  end

  def self.down
    add_column :politicians, :party, :string
  end
end
