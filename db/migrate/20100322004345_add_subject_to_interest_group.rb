class AddSubjectToInterestGroup < ActiveRecord::Migration
  def self.up
    add_column :interest_groups, :subject_id, :integer, :null => false
    constrain :interest_groups do |t|
      t.subject_id :reference => {:subjects => :id}
    end
  end

  def self.down
    deconstrain :interest_groups do |t|
      t.subject_id :reference
    end
    remove_column :interest_groups, :subject_id
  end
end
