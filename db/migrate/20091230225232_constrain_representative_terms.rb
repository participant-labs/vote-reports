class ConstrainRepresentativeTerms < ActiveRecord::Migration
  def self.up
    constrain :representative_terms do |t|
      t.politician_id :not_null => true, :reference => {:politicians => :id, :on_delete => :cascade}
      t.district :not_null => true
      t.state :not_null => true, :not_blank => true
    end
  end

  def self.down
    deconstrain :representative_terms do |t|
      t.politician_id :not_null, :reference
      t.district :not_null
      t.state :not_null, :not_blank
    end
  end
end