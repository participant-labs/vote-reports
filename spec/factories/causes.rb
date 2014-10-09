FactoryGirl.define do
  factory :cause do
    name { Forgery(:basic).text }
    description { Forgery(:basic).text }
    report
  end
end
