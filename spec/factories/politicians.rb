FactoryGirl.define do
  factory :politician do
    ignore do
      name "#{Forgery(:name).first_name} #{Forgery(:name).last_name}"
    end

    gov_track_id { rand(1000000) }
    first_name { name.split(' ', 2).first }
    last_name { name.split(' ', 2).last }
  end
end
