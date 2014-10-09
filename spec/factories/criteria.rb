FactoryGirl.define do
  factory :bill_criterion do
    report
    bill
    support true
  end

  factory :amendment_criterion do
    report
    amendment
    support true
  end
end
