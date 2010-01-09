Given /^a (.*)bill named "([^\"]*)"$/ do |attr, title|
  attrs =
    case attr.strip
    when 'current-congress'
      {
        :congress => Congress.find_by_meeting(Congress.current_meeting) || create_congress(:meeting => Congress.current_meeting),
        :introduced_on => Date.today
      }
    else
      {}
    end
  create_bill_title(:title => title, :bill => new_bill(attrs))
  Bill.reindex
end

Given /^(\d+) recent bills$/ do |count|
  count.to_i.times do
    create_bill
  end
end
