Transform /bill "([^\"]*)"/ do |title|
  Bill.with_title(title).first
end

Given /^an? (.*)bill named "([^\"]*)"$/ do |attrs, title|
  create_bill_roll = false
  bill = new_bill(
    attrs.split(', ').inject({}) do |attrs, attr|
      case attr.strip
      when 'current-congress'
        meeting = Congress.current_meeting
        attrs.merge!(
          :congress => Congress.find_by_meeting(meeting) || create_congress(:meeting => meeting),
          :introduced_on => Date.today
        )
      when 'previous-congress'
        meeting = Congress.current_meeting - 1
        attrs.merge!(
          :congress => Congress.find_by_meeting(meeting) || create_congress(:meeting => meeting),
          :introduced_on => 2.years.ago.to_date
        )
      when 'un-voted'
      when 'voted'
        create_bill_roll = true
      else
        raise "Unrecognize bill attr: #{attr}"
      end
      attrs
    end
  )
  title = create_bill_title(:title => title, :bill => bill)
  if create_bill_roll
    create_roll(:subject => title.bill)
  end
  Bill.reindex
end

Given /^(\d+) recent bills$/ do |count|
  count.to_i.times do
    create_bill
  end
end
