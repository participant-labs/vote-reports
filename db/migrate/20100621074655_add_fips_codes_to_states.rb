class AddFipsCodesToStates < ActiveRecord::Migration
  FIPS_CODES = {
    "01" => "AL",
    "02" => "AK",
    "04" => "AZ",
    "05" => "AR",
    "06" => "CA",
    "08" => "CO",
    "09" => "CT",
    "10" => "DE",
    "11" => "DC",
    "12" => "FL",
    "13" => "GA",
    "15" => "HI",
    "16" => "ID",
    "17" => "IL",
    "18" => "IN",
    "19" => "IA",
    "20" => "KS",
    "21" => "KY",
    "22" => "LA",
    "23" => "ME",
    "24" => "MD",
    "25" => "MA",
    "26" => "MI",
    "27" => "MN",
    "28" => "MS",
    "29" => "MO",
    "30" => "MT",
    "31" => "NE",
    "32" => "NV",
    "33" => "NH",
    "34" => "NJ",
    "35" => "NM",
    "36" => "NY",
    "37" => "NC",
    "38" => "ND",
    "39" => "OH",
    "40" => "OK",
    "41" => "OR",
    "42" => "PA",
    "44" => "RI",
    "45" => "SC",
    "46" => "SD",
    "47" => "TN",
    "48" => "TX",
    "49" => "UT",
    "50" => "VT",
    "51" => "VA",
    "53" => "WA",
    "54" => "WV",
    "55" => "WI",
    "56" => "WY",
    "60" => "AS",
    "64" => "FM",
    "66" => "GU",
    "68" => "MH",
    "69" => "MP",
    "70" => "PW",
    "72" => "PR",
    "74" => "UM",
    "78" => "VI"
  }

  def self.up
    rename_column :districts, :gid, :id
    
    add_column :us_states, :fips_code, :string
    FIPS_CODES.each_pair do |code, abbr|
      UsState.update_all({:fips_code => code}, {:abbreviation => abbr})
    end
    
    add_column :districts, :us_state_id, :integer
    constrain :districts, :us_state_id, :reference => {:us_states => :id}
    
    states = UsState.all.index_by(&:fips_code)
    District.paginated_each do |district|
      district.update_attribute(:us_state_id, states.fetch(district.state).id)
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
