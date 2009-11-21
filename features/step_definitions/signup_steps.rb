Given /^I signed up as "(.*)\/(.*)\/(.*)"$/ do |login, email, password|
  user = Factory :user, 
    :login                 => login,
    :email                 => email, 
    :password              => password,
    :password_confirmation => password
end