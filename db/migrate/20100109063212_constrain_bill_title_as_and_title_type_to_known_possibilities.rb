class ConstrainBillTitleAsAndTitleTypeToKnownPossibilities < ActiveRecord::Migration
  def self.up
    constrain :bill_titles do |t|
      t.as :whitelist => ["reported to senate", "agreed to by house and senate", "amended by house",
        "passed senate", "amended by senate", "introduced", "enacted", "reported to house", "passed house"]
      t.title_type :whitelist => ['short', 'official', 'popular']
    end
  end

  def self.down
    deconstrain :bill_titles do |t|
      t.as :whitelist
      t.title_type :whitelist
    end
  end
end
