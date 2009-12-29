class RemoveForeignerForeignKeyConstraints < ActiveRecord::Migration
  def self.up
    remove_foreign_key(:amendments, :column => 'bill_id')
    remove_foreign_key(:bill_criteria, :column => 'bill_id')
    remove_foreign_key(:bill_criteria, :column => 'report_id')
    remove_foreign_key(:bills, :column => 'congress_id')
    remove_foreign_key(:bills, :column => 'sponsor_id')
    remove_foreign_key(:reports, :column => 'user_id')
    remove_foreign_key(:presidential_terms, :column => 'politician_id')
    remove_foreign_key(:representative_terms, :column => 'politician_id')
    remove_foreign_key(:senate_terms, :column => 'politician_id')
    remove_foreign_key(:rolls, :column => 'congress_id')
    remove_foreign_key(:votes, :column => 'politician_id')
    remove_foreign_key(:votes, :column => 'roll_id')
  end

  def self.down
    transaction do
      add_foreign_key(:amendments, :bills, :dependent => :delete)
      add_foreign_key(:bill_criteria, :bills, :dependent => :delete)
      add_foreign_key(:bill_criteria, :reports, :dependent => :delete)
      add_foreign_key(:bills, :congresses, :dependent => :delete)
      add_foreign_key(:bills, :politicians, :column => 'sponsor_id', :dependent => :nullify)
      add_foreign_key(:reports, :users, :dependent => :delete)
      add_foreign_key(:presidential_terms, :politicians, :dependent => :delete)
      add_foreign_key(:representative_terms, :politicians, :dependent => :delete)
      add_foreign_key(:senate_terms, :politicians, :dependent => :delete)
      add_foreign_key(:rolls, :congresses, :dependent => :delete)
      add_foreign_key(:votes, :politicians, :dependent => :delete)
      add_foreign_key(:votes, :rolls, :dependent => :delete)
    end
  end
end
