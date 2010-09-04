class AddTopSubjectToReport < ActiveRecord::Migration
  def self.up
    add_column :reports, :top_subject_id, :integer
    add_index :reports, :top_subject_id
    add_foreign_key :reports, :subjects, :column => :top_subject_id, :dependent => :nullify
  end

  def self.down
    remove_column :reports, :top_subject_id
  end
end
