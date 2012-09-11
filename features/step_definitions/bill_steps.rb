Transform /bill "([^\"]*)"/ do |title|
  Bill.with_title(title).first
end

Given /^an? (.*)bill named "([^\"]*)"$/ do |attrs, title|
  create_bill_roll = create_pass_bill_roll = false
  bill = new_bill(
    attrs.split(', ').inject({}) do |attrs, attr|
      case attr.strip
      when 'current-congress'
        meeting = Congress.current_meeting
        attrs.merge!(
          congress: Congress.find_by_meeting(meeting) || create_congress(meeting: meeting),
          introduced_on: Date.today
        )
      when 'previous-congress'
        meeting = Congress.current_meeting - 1
        attrs.merge!(
          congress: Congress.find_by_meeting(meeting) || create_congress(meeting: meeting),
          introduced_on: 2.years.ago.to_date
        )
      when 'un-voted'
      when 'voted'
        create_bill_roll = true
      when 'pass-voted'
        create_pass_bill_roll = true
      else
        year = Integer(attr) rescue nil
        if year
          attrs.merge!(
            introduced_on: "#{year}/5/4"
          )
        else
          raise "Unrecognize bill attr: #{attr}"
        end
      end
      attrs
    end
  )
  title = create_bill_title(title: title, bill: bill)
  if create_bill_roll
    create_roll(subject: title.bill)
  end
  if create_pass_bill_roll
    create_roll(subject: title.bill, roll_type: 'On Passage')
  end
  Bill.solr_reindex
end

Given /^(\d+) recent bills$/ do |count|
  count.to_i.times do
    create_bill(introduced_on: 2.months.ago.to_date)
  end
end

Given /^(bill "[^\"]*") has a title "([^\"]*)"$/ do |bill, title|
  create_bill_title(bill: bill, title: title)
end

Given /^(bill "[^"]*") is sponsored by (politician "[^"]*")$/ do |bill, politician|
  bill.create_sponsorship(joined_on: bill.introduced_on, politician: politician, bill: bill)
end

Given /^(bill "[^"]*") is cosponsored by:$/ do |bill, table|
  table.map_column!('politician') {|name| Politician.with_name(name).first }
  table.hashes.each do |hash|
    create_cosponsorship(bill: bill, politician: hash['politician'])
  end
end
