module Us::StatesHelper
  def state_full_name(state)
    link_to_unless_current(state.full_name, us_state_path(state))
  end
  safe_helper :state_full_name
end
