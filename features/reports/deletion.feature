Feature: Browsing Reports
  In order to remove accidentally-created reports
  As a user
  I want to delete my reports

  Background:
    Given I am signed in
    And the following published reports by me:
      | name      | description                |
      | My Report | I made this because I care |

  Scenario: Deleting a report from the show page
    When I go to my reports page
    And I follow "My Report"
    And I follow "destroy"
    Then I should see "Successfully destroyed report."
    And I should not see "My Report"
  