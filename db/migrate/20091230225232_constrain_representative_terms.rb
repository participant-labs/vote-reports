class ConstrainRepresentativeTerms < ActiveRecord::Migration
  def self.up
    change_table :representative_terms do |t|
      t.change :politician_id, :integer, :null => false
      t.change :district, :integer, :null => false
      t.change :state, :string, :null => false
    end

    constrain :representative_terms do |t|
      t.politician_id :reference => {:politicians => :id, :on_delete => :cascade}
      t.state :not_blank => true
    end
  end

  def self.down
    change_table :representative_terms do |t|
      t.change :politician_id, :integer, :null => true
      t.change :district, :integer, :null => true
      t.change :state, :string, :null => true
    end

    deconstrain :representative_terms do |t|
      t.politician_id :reference
      t.state :not_blank
    end
  end
end