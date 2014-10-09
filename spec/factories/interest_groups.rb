FactoryGirl.define do
  factory :interest_group do
    name { Forgery(:basic).text }
    vote_smart_id { rand(100000000).to_s }
  end

  factory :interest_group_report do
    interest_group
    vote_smart_id { rand(100000000).to_s }
    timespan '2007'
  end

  factory :interest_group_rating do
    interest_group_report
    politician
    description { Forgery(:basic).text }
  end
end
