module ReportsHelper
  def report_embed_code(report)
    content_tag :iframe, '', :src => embed_report_url(report.id), :width => 200, :height => 500, :style => 'border: none;'
  end

  def report_name(report, opts = {})
    if report.cause && !opts[:cause_only]
      "#{report.name} (Cause)"
    else
      report.name
    end
  end

  def follower_count(report, other = false)
    followers = report.followers.count
    if other
      content_tag :p, "#{pluralize(followers - 1, 'other user')} following this report" if followers > 1
    elsif followers > 0
      content_tag :p, "#{pluralize(followers, 'user')} #{followers > 1 ? 'follow' : 'follows'} this report"
    end
  end

  def build_criteria_for(report, criteria_targets)
    if criteria_targets.first.is_a?(Bill)
      criteria_targets.map do |bill|
        report.bill_criteria.find_by_bill_id(bill.id) ||
          report.bill_criteria.build(:bill_id => bill.id)
      end
    else
      criteria_targets.map do |amendment|
        report.amendment_criteria.find_by_amendment_id(amendment.id) ||
          report.amendment_criteria.build(:amendment_id => amendment.id)
      end
    end
  end

  def report_step(report, step)
    if step.is_a?(String)
      content_tag :p, step
    else
      step.assert_valid_keys(:text, :why, :state_event, :confirm)
      content_tag :div, :class => 'clearfix' do
        content_tag(:p, step.fetch(:why))
        link_to(step.fetch(:text), user_report_path(report.user, report, :report => {:state_event => step.fetch(:state_event)}), :confirm => step.fetch(:confirm), :method => :put, :class => 'button')
      end
    end
  end

  def report_next_step(report)
    report_step(report, report.next_step)
  end
end
