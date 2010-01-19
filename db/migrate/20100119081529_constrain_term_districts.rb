class ConstrainTermDistricts < ActiveRecord::Migration
  def self.up
    PoliticianTerm.update_all({:district => nil}, {:district => -1})
    constrain :politician_terms do |t|
      t.district :within => 0..53
      t.senate_class :within => 1..3
    end
  end

  def self.down
    deconstrain :politician_terms do |t|
      t.district :within
      t.senate_class :within
    end
  end
end
