Feature: Issue Creation
  In order to collect causes into higher-level constructs
  As an admin
  I want to create & populate issues

  Scenario: Creating an issue
    Given a cause named "Gun Rights"
    And a cause named "Gun Control"
    And I am signed in as an Admin
    And I am on the issues page
    When I follow "Create a new Issue"
    And I fill in "Title" with "Guns"
    And I check "Gun Rights"
    And I check "Gun Control"
    And I press "Save"
    Then I should be on the issue page for "Guns"
    And I should see "Gun Rights"
    And I should see "Gun Control"
