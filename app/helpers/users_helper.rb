module UsersHelper
  def general_user_path(user)
    if permitted_to?(:show, user)
      user_path(user)
    else
      user_reports_path(user)
    end
  end
end
