Factory.define :user do |f|
  f.email {Factory.next :email}
  f.username {Factory.next :username}
  f.password "password"
  f.password_confirmation "password"
end

Factory.define :report do |f|
  f.name "My report"
  f.user {|u| u.association(:user) }
end

Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.sequence :username do |n|
  "user#{n}"
end