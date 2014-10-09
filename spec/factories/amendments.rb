FactoryGirl.define do
  factory :amendment do
    purpose { Forgery(:basic).text }
    description { Forgery(:basic).text }
    sponsor { create([:politician, :committee_meeting].sample) }
    bill
    number { rand(1000) }
    offered_on { "13/12/2009" }
    chamber { ['h', 's'].sample }
    congress
  end
end
