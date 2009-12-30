class ConstrainPresidentialTerms < ActiveRecord::Migration
  def self.up
    constrain :presidential_terms do |t|
      t.politician_id :reference => {:politicians => :id, :on_delete => :cascade}, :not_null => true
      t.party :not_null => true, :not_blank => true
    end
  end

  def self.down
    deconstrain :presidential_terms do |t|
      t.politician_id :reference
      t.party :not_null, :not_blank
    end
  end
end
