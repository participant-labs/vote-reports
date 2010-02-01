class District < ActiveRecord::Base
  belongs_to :state, :class_name => 'UsState', :foreign_key => :us_state_id
end
