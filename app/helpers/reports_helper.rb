module ReportsHelper
  def build_criteria_for(report, bills)
    bills.map do |bill|
      report.bill_criteria.find_by_bill_id(bill.id) ||
        report.bill_criteria.build(:bill_id => bill.id)
    end
  end

  def report_path_components(report)
    report.user ? [report.user, report] : report.interest_group
  end

  def path_for_report(report, options = {})
    polymorphic_path(report_path_components(report), options)
  end

  def report_next_step(report)
    next_step = report.next_step
    if next_step.is_a?(String)
      content_tag :p, report.next_step
    else
      next_step.assert_valid_keys(:text, :why, :state_event, :confirm)
      content_tag :div, :class => 'buttons clearfix' do
        content_tag(:p, next_step.fetch(:why)) \
          + link_to(next_step.fetch(:text), user_report_path(current_user, report, :report => {:state_event => next_step.fetch(:state_event)}), :confirm => next_step.fetch(:confirm), :method => :put)
      end
    end
  end
end
