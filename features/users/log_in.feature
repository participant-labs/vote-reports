Feature: Log in
  In order to get access to protected sections of the site
  A user
  Should be able to log in
  
   Scenario: User is not signed up
      Given there is no user with "email@person.com"
      When I go to the login page
      And I log in as "email@person.com/password"
      Then I should see "Email is not valid"
      And I should not see "Logged in successfully"
  
   Scenario: User enters wrong password
      Given I signed up as "email@person.com/password"
      When I go to the login page
      And I log in as "email@person.com/wrongpassword"
      Then I should see "Password is not valid"
      And I should not see "Logged in successfully"
      
    Scenario: User enters wrong email address
       Given I signed up as "email@person.com/password"
       When I go to the login page
       And I log in as "email2@person.com/password"
       Then I should see "Email is not valid"
       And I should not see "Logged in successfully"
      
   Scenario: User signs in successfully using email address
      Given I signed up as "email@person.com/password"
      When I go to the login page
      And I log in as "email@person.com/password"
      Then I should see "Logged in successfully"
      