FactoryGirl.define do
  factory :party do
    name { Forgery(:basic).text }
  end
end
