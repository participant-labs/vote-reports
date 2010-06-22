class AddFipsCodesToStates < ActiveRecord::Migration
  def self.up
    District.reset_column_information
    rename_column :districts, :gid, :id
    
    add_column :us_states, :fips_code, :string
    UsState::FIPS_CODES.each_pair do |code, abbr|
      UsState.update_all({:fips_code => code}, {:abbreviation => abbr})
    end
    
    add_column :districts, :us_state_id, :integer
    constrain :districts, :us_state_id, :reference => {:us_states => :id}
    
    states = UsState.all.index_by(&:abbreviation)
    District.paginated_each do |district|
      district.update_attribute(:us_state_id, states.fetch(district.state_name).id)
      print '.'
    end
    puts
    change_column :districts, :us_state_id, :integer, :null => false
    remove_columns :districts, :state, :state_name
    remove_index :congressional_districts, :name => 'index_districts_on_us_state_id'
    add_index :districts, :us_state_id
  end

  def self.down
    raise "nope"
  end
end
