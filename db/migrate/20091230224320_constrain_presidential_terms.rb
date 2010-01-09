class ConstrainPresidentialTerms < ActiveRecord::Migration
  def self.up
    change_table :presidential_terms do |t|
      t.change :politician_id, :integer, :null => false
      t.change :party_id, :integer, :null => false
    end

    constrain :presidential_terms do |t|
      t.politician_id :reference => {:politicians => :id, :on_delete => :cascade}
    end
  end

  def self.down
    change_table :presidential_terms do |t|
      t.change :politician_id, :integer, :null => true
      t.change :party_id, :integer, :null => true
    end

    deconstrain :presidential_terms do |t|
      t.politician_id :reference
    end
  end
end
