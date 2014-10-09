FactoryGirl.define do
  sequence :state do |n|
    UsState.all.sample
  end

  factory :congressional_district do
    state
    district
  end

  factory :congressional_district_zip_code do
    congressional_district
    zip_code
  end
end
