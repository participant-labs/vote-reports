class CreateModeratorships < ActiveRecord::Migration
  def self.up
    create_table :moderatorships do |t|
      t.integer :user_id, :null => false
      t.integer :created_by_id, :null => false

      t.timestamps
    end
    constrain :moderatorships do |t|
      t.user_id :reference => {:users => :id}
      t.created_by_id :reference => {:users => :id}
    end
  end

  def self.down
    drop_table :moderatorships
  end
end
