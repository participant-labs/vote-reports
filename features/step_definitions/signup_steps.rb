Given /^I signed up as:$/ do |table|
  table.hashes.each do |hash|
    create_user(hash.merge('password_confirmation' => hash['password']))
  end
end