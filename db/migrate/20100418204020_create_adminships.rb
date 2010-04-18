class CreateAdminships < ActiveRecord::Migration
  def self.up
    create_table :adminships do |t|
      t.integer :user_id, :null => false
      t.integer :created_by_id, :null => false

      t.timestamps
    end
    constrain :adminships do |t|
      t.user_id :reference => {:users => :id}
      t.created_by_id :reference => {:users => :id}
    end
  end

  def self.down
    drop_table :adminships
  end
end
