class ReplaceBillTitleAs < ActiveRecord::Migration
  def self.up
    transaction do
      add_column :bill_titles, :bill_title_as_id, :integer
      deconstrain :bill_title_as do |t|
        t.as :whitelist
      end
      constrain :bill_title_as do |t|
        t.as :whitelist => ["reported to senate", "agreed to by house and senate", "amended by house",
          "passed senate", "amended by senate", "introduced", "enacted", "reported to house", "passed house", 'popular']
      end

      [
        'enacted',
        'agreed to by house and senate',
        'passed house',
        'passed senate',
        'amended by senate',
        'amended by house',
        'reported to senate',
        'reported to house',
        'introduced',
        'popular'
      ].each_with_index do |as, index|

        as = BillTitleAs.create(:as => as, :sort_order => index)
        BillTitle.update_all({:bill_title_as_id => as.id}, {:as => as.as})

      end

      bad_titles = BillTitle.all(:conditions => {:bill_title_as_id => nil})
      raise bad_titles.inspect if bad_titles.present?
      change_column :bill_titles, :bill_title_as_id, :integer, :null => false
      constrain :bill_titles do |t|
        t.bill_title_as_id :reference => {:bill_title_as => :id}
      end
      remove_column :bill_titles, :as
    end
  end

  def self.down
  end
end
