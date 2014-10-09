FactoryGirl.define do
  factory :committee do
    display_name { Forgery(:basic).text }
    code { Forgery(:basic).text }
  end

  factory :committee_meeting do
    committee
    congress
    name { Forgery(:basic).text }
  end
end
