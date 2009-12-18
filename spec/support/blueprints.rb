require 'machinist/active_record'
require 'sham'

Sham.define do
  opencongress_id  {|n| 300000 + n  }
  gov_track_id     {|n| 300000 + n  }
  title            { Forgery(:basic).text }
  email            { Forgery(:internet).email_address }
  username         { Forgery(:internet).user_name }
  meeting          { Forgery(:basic).number(:at_most => 111) }
  first_name       { Forgery(:name).first_name }
  last_name        { Forgery(:name).last_name }
end

User.blueprint do |f|
  email
  username
  password "password"
  password_confirmation "password"
end

Report.blueprint do |f|
  name { Sham.title }
  user { User.make }
end

Amendment.blueprint do |f|
  title
  bill { Bill.make }
end

Congress.blueprint do |f|
  meeting
end

Bill.blueprint do |f|
  title
  opencongress_id
  gov_track_id
  bill_type "H.Res.3549"
  sponsor { Politician.make }
  congress { Congress.make }
end

BillCriterion.blueprint do |f|
  report { Report.make }
  bill { Bill.make }
end

Politician.blueprint do |f|
  first_name
  last_name
  gov_track_id
end

Vote.blueprint do |f|
  politician { Politician.make }
  roll { Roll.make }
  vote { %w[+ - P 0].rand }
end

Roll.blueprint do |f|
  congress { Congress.make }
  subject { Bill.make }
  opencongress_id
end

RepresentativeTerm.blueprint do |f|
  congress { Congress.find_or_create_by_meeting(111) }
end

SenateTerm.blueprint do |f|
  congress { Congress.find_or_create_by_meeting(111) }
end
