Given /^I signed up as "(.*)\/(.*)"$/ do |email, password|
  create_user(
    :email                 => email, 
    :password              => password,
    :password_confirmation => password
  )
end