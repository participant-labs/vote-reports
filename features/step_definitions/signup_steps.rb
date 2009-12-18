Given /^I signed up as "(.*)\/(.*)"$/ do |email, password|
  User.make(
    :email                 => email, 
    :password              => password,
    :password_confirmation => password
  )
end