class UsState < ActiveRecord::Base
  def unincorporated?
    state_type != 'state'
  end
end