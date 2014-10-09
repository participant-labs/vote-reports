FactoryGirl.define do
  sequence :meeting do |n|
    Forgery(:basic).number(at_least: 103, at_most: 111)
  end

  sequence :bill_type do |n|
    Forgery(:basic).text(at_least: 2, at_most: 2, allow_numeric: false, allow_upper: false)
  end

  sequence :bill_number do |n|
    Forgery(:basic).number(at_most: 9999)
  end

  factory :bill do
    opencongress_id { "#{generate :meeting}-#{bill_type}#{bill_number}" }
    gov_track_id { "#{bill_type}#{generate :meeting}-#{bill_number}" }
    introduced_on { 2.years.ago.to_date }
    bill_type 'hr'
    bill_number
    congress { Congress.find_or_create_by_meeting(rand(200)) }
  end

  factory :bill_title do
    title { Forgery(:basic).text }
    title_type 'official'
    as { BillTitleAs.all.sample }
    bill
  end
end
