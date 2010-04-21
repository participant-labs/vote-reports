Feature: Editing Reports
  In order to correction objectionable speech and quarantine reports
  As an admin
  I want to edit other users reports

  Background:
    Given the following published reports:
      | name      | description                |
      | My Report | I made this because I care |
    And I am signed in as an Admin

  Scenario: Admin edits a report and is redirected to the same on success
    When I go to the report page for "My Report"
    And I follow "Edit Report"
    And I fill in "Name" with "My Best Report"
    And I fill in "Description" with "You should read this because I'm awesome"
    And I press "Update Report"
    Then I should see "Successfully updated report."
    And I should be on the report page for "My Best Report"
    And I should see "My Best Report"
    And I should see "You should read this because I'm awesome"
    And I should not see "My Report"
    And I should not see "I made this because I care"
