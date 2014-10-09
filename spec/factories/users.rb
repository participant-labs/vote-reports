FactoryGirl.define do
  factory :user do
    email { Forgery(:internet).email_address }
    username { Forgery(:basic).text }
    password 'password'
    password_confirmation 'password'
    state 'active'
  end
end
