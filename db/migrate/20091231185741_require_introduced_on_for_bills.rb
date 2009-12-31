class RequireIntroducedOnForBills < ActiveRecord::Migration
  def self.up
    constrain :bills do |t|
      t.introduced_on :not_null => true
    end
  end

  def self.down
    deconstrain :bills do |t|
      t.introduced_on :not_null
    end
  end
end
