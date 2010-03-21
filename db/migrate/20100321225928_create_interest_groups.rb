class CreateInterestGroups < ActiveRecord::Migration
  def self.up
    create_table :interest_groups do |t|
      t.integer :vote_smart_id, :null => false
      t.string :ancestry

      t.string :name, :null => false
      t.text :description
      t.string :email
      t.string :url
      t.string :contact_name
      t.string :phone1
      t.string :phone2
      t.string :fax
      t.string :address
      t.string :city
      t.string :state
      t.string :zip

      t.timestamps
    end

    add_index :interest_groups, :ancestry
    add_index :interest_groups, :vote_smart_id, :unique => true
  end

  def self.down
    remove_index :interest_groups, :ancestry
    remove_index :interest_groups, :vote_smart_id

    drop_table :interest_groups
  end
end
