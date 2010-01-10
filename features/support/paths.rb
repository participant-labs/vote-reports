module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
    when /my reports page/i
      user_reports_path(@current_user)
    when /my report page for "(.+)"/i
      user_report_path(@current_user, Report.find_by_name($1))
    when /my profile page/i
      user_path(@current_user)
    when /the politician page for "(.+)"/
      politician_path(Politician.find_by_full_name($1))
    when /the bill page for "(.+)"/
      bill_path(BillTitle.find_by_title($1).bill)

    when /the (.+) page/i
      send("#{$1}_path")

    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
