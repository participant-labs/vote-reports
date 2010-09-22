class AddCurrentCandidacyIdToPoliticians < ActiveRecord::Migration
  def self.up
    add_column :politicians, :current_candidacy_id, :integer
    add_foreign_key :politicians, :candidacies, :column => :current_candidacy_id, :dependent => :nullify
  end

  def self.down
    remove_column :politicians, :current_candidacy_id
  end
end
