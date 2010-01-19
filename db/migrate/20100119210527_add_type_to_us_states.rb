class AddTypeToUsStates < ActiveRecord::Migration
  def self.up
    add_column :us_states, :state_type, :string
    UsState.update_all({:state_type => 'territory'}, {:full_name => ["Guam", "District of Columbia", "Northern Mariana Islands", "American Samoa", "Virgin Islands", 'Puerto Rico', 'Philippine Islands', 'Marshall Islands', 'Federated States of Micronesia', 'Territory of Orleans', 'Territory of Dakota']})
    UsState.update_all({:state_type => 'military'}, {:full_name => ['Armed Forces Africa, Canada, Europe and Middle East', 'Armed Forces Americas (except Canada)', 'Armed Forces Pacific']})
    UsState.update_all({:state_type => 'state'}, {:state_type => nil})

    change_column :us_states, :state_type, :string, :null => false
  end

  def self.down
    remove_column :us_states, :state_type
  end
end
