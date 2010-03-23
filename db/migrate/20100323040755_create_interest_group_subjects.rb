class CreateInterestGroupSubjects < ActiveRecord::Migration
  def self.up
    create_table :interest_group_subjects do |t|
      t.integer :interest_group_id, :null => false
      t.integer :subject_id, :null => false

      t.timestamps
    end

    constrain :interest_group_subjects do |t|
      t.interest_group_id :reference => {:interest_groups => :id}
      t.subject_id :reference => {:subjects => :id}
    end

    add_index :interest_group_subjects, :interest_group_id
    add_index :interest_group_subjects, :subject_id
    add_index :interest_group_subjects, [:interest_group_id, :subject_id], :unique => true, :name => 'index_interest_groups_subjects_on_group_and_subject'

    remove_column :interest_groups, :subject_id
  end

  def self.down
    drop_table :interest_group_subjects
    add_column :interest_groups, :subject_id, :integer
  end
end
