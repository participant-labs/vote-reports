module Us::StatesHelper
  def state_full_name(state)
    link_to_unless_current("State of #{state.full_name}", us_state_path(state))
  end

  def state_name(state)
    link_to_unless_current(state.full_name, us_state_path(state))
  end

  def state_title(state)
    "The State of #{state.full_name}"
  end
end
