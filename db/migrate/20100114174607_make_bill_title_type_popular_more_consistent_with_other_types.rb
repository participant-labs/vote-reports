class MakeBillTitleTypePopularMoreConsistentWithOtherTypes < ActiveRecord::Migration
  def self.up
    transaction do
      deconstrain :bill_titles do |t|
        t.title_type :whitelist
        t.as :whitelist
      end
      BillTitle.update_all({:title_type => 'short', :as => 'popular'}, {:title_type => 'popular'})
      change_column :bill_titles, :title_type, :string, :null => false
      change_column :bill_titles, :as, :string, :null => false
      constrain :bill_titles do |t|
        t.as :whitelist => ["reported to senate", "agreed to by house and senate", "amended by house",
          "passed senate", "amended by senate", "introduced", "enacted", "reported to house", "passed house", 'popular']
        t.title_type :whitelist => ['short', 'official']
      end
    end
  end

  def self.down
  end
end
