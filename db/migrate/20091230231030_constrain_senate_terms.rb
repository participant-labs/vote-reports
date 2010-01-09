class ConstrainSenateTerms < ActiveRecord::Migration
  def self.up
    change_table :senate_terms do |t|
      t.change :politician_id, :integer, :null => false
      t.change :senate_class, :integer, :null => false
      t.change :state, :string, :null => false
    end

    constrain :senate_terms do |t|
      t.politician_id :reference => {:politicians => :id, :on_delete => :cascade}
      t.state :not_blank => true
      t.url :not_blank => true
    end
  end

  def self.down
    change_table :senate_terms do |t|
      t.change :politician_id, :integer, :null => true
      t.change :senate_class, :integer, :null => true
      t.change :state, :string, :null => true
    end

    deconstrain :senate_terms do |t|
      t.politician_id :reference
      t.state :not_blank
      t.url :not_blank
    end
  end
end
