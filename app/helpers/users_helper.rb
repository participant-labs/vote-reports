module UsersHelper
  def general_user_path(user)
    if current_user == user
      root_path
    elsif permitted_to?(:show, user)
      user_path(user)
    else
      user_reports_path(user)
    end
  end
end
