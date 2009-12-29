class AddForeignKeyConstraintsWhereAppropriate < ActiveRecord::Migration
  def self.up
    add_foreign_key(:amendments, :bills)
    add_foreign_key(:bill_criteria, :bills)
    add_foreign_key(:bill_criteria, :reports)
    add_foreign_key(:bills, :congresses)
    add_foreign_key(:bills, :politicians, :column => 'sponsor_id')
    add_foreign_key(:reports, :users)
    add_foreign_key(:representative_terms, :politicians)
    add_foreign_key(:representative_terms, :congresses)
    add_foreign_key(:senate_terms, :politicians)
    add_foreign_key(:senate_terms, :congresses)
    add_foreign_key(:rolls, :congresses)
    add_foreign_key(:votes, :politicians)
    add_foreign_key(:votes, :rolls)
  end

  def self.down
    remove_foreign_key(:amendments, :column => 'bill_id')
    remove_foreign_key(:bill_criteria, :column => 'bill_id')
    remove_foreign_key(:bill_criteria, :column => 'report_id')
    remove_foreign_key(:bills, :column => 'congress_id')
    remove_foreign_key(:bills, :column => 'sponsor_id')
    remove_foreign_key(:reports, :column => 'user_id')
    remove_foreign_key(:representative_terms, :column => 'politician_id')
    remove_foreign_key(:representative_terms, :column => 'congress_id')
    remove_foreign_key(:senate_terms, :column => 'politician_id')
    remove_foreign_key(:senate_terms, :column => 'congress_id')
    remove_foreign_key(:rolls, :column => 'congress_id')
    remove_foreign_key(:votes, :column => 'politician_id')
    remove_foreign_key(:votes, :column => 'roll_id')
  end
end
