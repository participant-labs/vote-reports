class RollSubjectIsPolymorphic < ActiveRecord::Migration
  def self.up
    rename_column :rolls, :bill_id, :subject_id
    add_column :rolls, :subject_type, :string
  end

  def self.down
    rename_column :rolls, :subject_id, :bill_id
    remove_column :rolls, :subject_type
  end
end
