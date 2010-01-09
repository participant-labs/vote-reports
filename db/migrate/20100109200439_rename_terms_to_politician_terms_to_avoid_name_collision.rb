class RenameTermsToPoliticianTermsToAvoidNameCollision < ActiveRecord::Migration
  def self.up
    rename_table :terms, :politician_terms
  end

  def self.down
    rename_table :politician_terms, :terms
  end
end
