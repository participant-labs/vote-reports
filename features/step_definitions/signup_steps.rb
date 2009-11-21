Given /^I signed up as "(.*)\/(.*)"$/ do |email, password|
  user = Factory :user, 
    :email                 => email, 
    :password              => password,
    :password_confirmation => password
end