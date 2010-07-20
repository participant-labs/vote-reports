Feature: Sign up
  In order to get access to protected sections of the site
  A user
  Should be able to sign up
  
    Scenario: User signs up with invalid data
      When I go to the signup page
      And I fill in "Username" with "nobody"
      And I fill in "Email" with "invalidemail"
      And I fill in "Password" with "password"
      And I press "Sign up"
      Then I should see error messages
      
    Scenario: User signs up with valid data
      When I go to the signup page
      And I fill in "Username" with "James"
      And I fill in "Email" with "email@person.com"
      And I fill in "Password" with "password"
      And I fill in "Password confirmation" with "password"
      And I press "Sign up"
      Then I should see "Thanks for signing up. Welcome to VoteReports."
      And I should be on the user page for "James"

    Scenario: User signs up from another page and is sent to their user page
      Given a published report named "Published Report"
      When I go to the report page for "Published Report"
      And I follow "Log in"
      And I follow "No account? Signup here"
      And I fill in "Username" with "James"
      And I fill in "Email" with "email@person.com"
      And I fill in "Password" with "password"
      And I fill in "Password confirmation" with "password"
      And I press "Sign up"
      Then I should see "Thanks for signing up. Welcome to VoteReports."
      And I should be on the user page for "James"
