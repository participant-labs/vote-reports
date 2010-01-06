class CreateSubjects < ActiveRecord::Migration
  def self.up
    transaction do
      create_table :subjects do |t|
        t.string :name, :null => false
      end
      constrain :subjects do |t|
        t.name :not_blank => true
      end
    end
  end

  def self.down
    drop_table :subjects
  end
end
