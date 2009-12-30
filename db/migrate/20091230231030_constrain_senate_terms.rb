class ConstrainSenateTerms < ActiveRecord::Migration
  def self.up
    constrain :senate_terms do |t|
      t.politician_id :not_null => true, :reference => {:politicians => :id, :on_delete => :cascade}
      t.senate_class :not_null => true
      t.party :not_blank => true
      t.state :not_null => true, :not_blank => true
      t.url :not_blank => true
    end
  end

  def self.down
    deconstrain :senate_terms do |t|
      t.politician_id :not_null, :reference
      t.senate_class :not_null
      t.party :not_blank
      t.state :not_null, :not_blank
      t.url :not_blank
    end
  end
end
