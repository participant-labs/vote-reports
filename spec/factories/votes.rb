FactoryGirl.define do
  factory :roll do
    congress { Congress.all.sample }
    association :subject, factory: :bill
    year { rand(200) + 1810 }
    number { rand(10000) }
    where { ['house', 'senate'].sample }
    result { Forgery(:basic).text }
    required { Forgery(:basic).text }
    question { Forgery(:basic).text }
    roll_type { Forgery(:basic).text }
    voted_at '1/1/2004'
    aye { rand(500) }
    nay { rand(500) }
    not_voting { rand(500) }
    present { rand(500) }
  end

  factory :vote do
    politician
    roll
    vote { %w[+ - P 0].sample }
  end
end
