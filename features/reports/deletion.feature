Feature: Deleting Reports
  In order to remove accidentally-created reports
  As a user
  I want to delete my reports

  Scenario: Deleting my report from the show page
    Given I am signed in
    And I have the following published report:
      | name      | description                |
      | My Report | I made this because I care |
    When I go to my reports page
    And I follow "My Report"
    And I follow "destroy"
    Then I should see "Successfully destroyed report."
    And I should not see "My Report"

  Scenario: Attempting to deleting someone else's report from the show page
    Given I am signed in
    And I have the following published report:
      | name      | description                |
      | My Report | I made this because I care |
    When I go to my reports page
    And I follow "My Report"
    Then I should not see "destroy"

  Scenario: Attempting to deleting a report while logged out
    Given a published report named "My Report"
    When I go to the report page for "My Report"
    Then I should not see "destroy"
