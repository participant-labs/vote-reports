FactoryGirl.define do
  factory :congress do
    sequence(:meeting) {|i| i }
  end
end
