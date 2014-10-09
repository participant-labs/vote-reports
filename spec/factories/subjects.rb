FactoryGirl.define do
  factory :subject do
    name { Forgery::LoremIpsum.words(4) }
    slug { Forgery(:basic).text }
  end
end
