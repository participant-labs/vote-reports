module ReportsHelper
  def build_criteria_for(report, bills)
    bills.map do |bill|
      report.bill_criteria.find_by_bill_id(bill.id) ||
        report.bill_criteria.build(:bill_id => bill.id)
    end
  end

  def report_path_components(report)
    if report.user
      [report.user, report]
    else
      report.owner
    end
  end

  def path_for_report(report, options = {})
    polymorphic_path(report_path_components(report), options)
  end

  def report_step(report, step)
    if step.is_a?(String)
      content_tag :p, step
    else
      step.assert_valid_keys(:text, :why, :state_event, :confirm)
      content_tag :div, :class => 'buttons clearfix' do
        content_tag(:p, step.fetch(:why))
        link_to(step.fetch(:text), user_report_path(current_user, report, :report => {:state_event => step.fetch(:state_event)}), :confirm => step.fetch(:confirm), :method => :put)
      end
    end
  end

  def report_next_step(report)
    report_step(report, report.next_step)
  end
end
