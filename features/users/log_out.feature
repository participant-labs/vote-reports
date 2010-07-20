@homepagey
Feature: Log out
  To protect my account from unauthorized access
  A signed in user
  Should be able to log out

  Scenario: User logs out
    Given I signed up as:
      | email            | password |
      | email@person.com | password |
    When I log in as "email@person.com/password"
    Then I should see "Logged in successfully"
    When I sign out
    Then I should see "You have been logged out"     
