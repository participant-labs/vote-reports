Feature: Log in
  In order to get access to protected sections of the site
  A user
  Should be able to log in
  
   Scenario: User is not signed up
      Given there is no user with "email@person.com"
      When I go to the log in page
      And I log in as "email@person.com/password"
      Then I should see "Email is not valid"
      And I should not be signed in      
  
   Scenario: User enters wrong password
      Given I signed up as "email@person.com/password"
      When I go to the log in page
      And I log in as "email@person.com/wrongpassword"
      Then I should see "Password didn’t match. Try again or click “forgotten your password”"
      And I should not be signed in
      
    Scenario: User enters wrong email address
       Given I signed up as "user1/email@person.com/password"
       When I go to the log in page
       And I log in as "email2@person.com/password"
       Then I should see "Username or email address not recognised. Try again or click “forgotten your password”"
       And I should not be signed in
      
   Scenario: User signs in successfully using email address
      Given I signed up as "user1/email@person.com/password"
      When I go to the log in page
      And I log in as "email@person.com/password"
      Then I should see "Logged in successfully"
      And I should be signed in
      
   Scenario: User signs in successfully using username
      Given I signed up as "user1/email@person.com/password"
      When I go to the log in page
      And I log in as "user1/password"
      Then I should see "Logged in successfully"
      And I should be signed in