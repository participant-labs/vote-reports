class CreateInterestGroupRatings < ActiveRecord::Migration
  def self.up
    create_table :interest_group_ratings do |t|
      t.integer :interest_group_id, :null => false
      t.integer :politician_id, :null => false
      t.string :vote_smart_id, :null => false
      t.string :rating, :null => false
      t.string :description, :null => false
      t.string :time_span, :null => false

      t.timestamps
    end

    constrain :interest_group_ratings do |t|
      t.interest_group_id :reference => {:interest_groups => :id}
      t.politician_id :reference => {:politicians => :id}
    end

    add_index :interest_group_ratings, :interest_group_id
    add_index :interest_group_ratings, :politician_id
    add_index :interest_group_ratings, [:interest_group_id, :politician_id], :name => 'index_interest_group_ratings_on_p_and_ig'
  end

  def self.down
    remove_index :interest_group_ratings, :interest_group_id
    remove_index :interest_group_ratings, :politician_id
    remove_index :interest_group_ratings, [:interest_group_id, :politician_id]

    drop_table :interest_group_ratings
  end
end
