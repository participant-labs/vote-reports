class ConstrainTermsStartAndEndDates < ActiveRecord::Migration
  def self.up
    change_table :politician_terms do |t|
      t.change :started_on, :date, :null => false
      t.change :ended_on, :date, :null => false
    end
    constrain :politician_terms do |t|
      t.state :not_blank => true
      t.url :not_blank => true
    end
  end

  def self.down
    change_table :politician_terms do |t|
      t.change :started_on, :date, :null => true
      t.change :ended_on, :date, :null => true
    end
    decontrain :politician_terms do |t|
      t.state :not_blank
      t.url :not_blank
    end
  end
end
