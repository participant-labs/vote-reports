Factory.define :user do |f|
  f.email {Factory.next :email}
  f.username {Factory.next :username}
  f.password "password"
  f.password_confirmation "password"
end

Factory.define :report do |f|
  f.name { Factory.next :text }
  f.user {|u| u.association(:user) }
end

Factory.define :bill do |f|
  f.title { Factory.next :text }
  f.opencongress_id { Factory.next :opencongress_id }
end

Factory.define :bill_criterion do |f|
  f.report {|r| r.association(:report) }
  f.bill {|b| b.association(:bill) }
end

Factory.define :politician do |f|
  f.first_name { Forgery(:name).first_name }
  f.last_name { Forgery(:name).last_name }
end

Factory.define :vote do |f|
  f.politician {|p| p.association(:politician) }
  f.bill {|b| b.association(:bill) }
  f.vote { rand(2) == 1 }
end

Factory.sequence :text do |n|
  "#{n}#{Forgery(:basic).text}"
end

Factory.sequence :opencongress_id do |n|
  "#{Bill.last.opencongress_id.to_i + 1}"
end

Factory.sequence :email do |n|
  "#{n}#{Forgery(:internet).email_address}"
end

Factory.sequence :username do |n|
  "#{n}#{Forgery(:internet).user_name}"
end