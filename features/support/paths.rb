module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    when /the cause page for "(.*)"/
      cause_path(Cause.find_by_name($1))

    when /user "(.*)"'s page for report "(.*)"/
      user = User.find_by_username($1)
      user_report_path(user, user.reports.find_by_name($2))
    when /my report page for "(.+)"/i
      user_report_path(current_user, current_user.reports.find_by_name($1))
    when /the edit page for my report "(.+)"/i
      edit_user_report_path(current_user, current_user.reports.find_by_name($1))
    when /the new bills page for my report "(.+)"/
      new_user_report_bill_criterion_path(current_user, Report.find_by_name($1))
    when /the edit bills page for my report "(.+)"/
      user_report_bill_criteria_path(current_user, Report.find_by_name($1))
    when /the new bills page for the report "(.+)"/
      new_user_report_bill_criterion_path(Report.find_by_name($1).user, Report.find_by_name($1))
    when /the edit bills page for the report "(.+)"/
      user_report_bill_criteria_path(Report.find_by_name($1).user, Report.find_by_name($1))
    when /the edit image page for the report "(.+)"/
      edit_user_report_image_path(Report.find_by_name($1).user, Report.find_by_name($1))

    when /my reports page/i
      user_reports_path(current_user)
    when /the reports page for "(.*)"/i
      user_reports_path(User.find_by_username($1))
    when /my profile page/i
      user_path(current_user)

    when /the user page for "(.+)"/i
      user_path(User.find_by_username($1))
    when /the edit user page for "(.+)"/i
      edit_user_path(User.find_by_username($1))
    when /the politician page for "(.+)"/
      politician_path(Politician.with_name($1).first)
    when /the roll page for "(.+)"/
      roll_path(Roll.find_by_question($1))

    when /the report page for "(.+)"/
      report = Report.find_by_name($1)
      user_report_path(report.user, report)

    when /the bill page for "(.+)"/
      bill_path(BillTitle.find_by_title($1).bill)
    when /the subject page for "(.+)"/
      subject_path(Subject.find_by_name($1))

    when /the interest group page for "(.+)"/
      interest_group_path(InterestGroup.find_by_name($1))
    when /the edit interest group image page for "(.+)"/
      edit_interest_group_image_path(InterestGroup.find_by_name($1))

    when /^the (.+) page$/i
      send("#{$1.gsub(' ', '_')}_path")

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
