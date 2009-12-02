Feature: User edits reports
  In order to correct mistakes and maintain consistency
  As a user
  I want to edit my reports

  Background:
    Given I am signed in
    And the following published reports by me:
      | name      | description                |
      | My Report | I made this because I care |

  Scenario: User edits a report
    When I go to my reports page
    And I follow "My Report"
    And I follow "edit"
    And I fill in "Name" with "My Best Report"
    And I fill in "Description" with "You should read this because I'm awesome"
    And I press "Save"
    Then I should see "Report was successfully updated"
    And I should see "My Best Report"
    And I should see "You should read this because I'm awesome"
    And I should not see "My Report"
    And I should not see "I made this because I care"

  Scenario: User tries to edit a report to not have a name
    When I go to my reports page
    And I follow "My Report"
    And I follow "edit"
    And I fill in "Name" with ""
    And I press "Save"
    Then I should see "Name can't be blank"
