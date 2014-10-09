FactoryGirl.define do
  factory :cosponsorship do
    bill
    politician
    joined_on { 1.month.ago }
  end
end
