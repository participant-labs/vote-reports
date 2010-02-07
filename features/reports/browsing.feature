Feature: Browsing Reports
  In order to find interesting reports
  As a user
  I want to browse reports

  Scenario: Browse excludes unpublished reports
    Given a report named "Empty Report"
    And an unscored report named "Unscored Report"
    And a scored report named "Scored Report"
    And a published report named "Active Report"
    When I go to the reports page
    Then I should see "Active Report"
    But I should not see "Empty Report"
    And I should not see "Unscored Report"
    And I should not see "Scored Report"

  Scenario: My Reports doesn't exclude empty reports
    Given I am signed in
    And I have a report named "Empty Report"
    And I have an unscored report named "Unscored Report"
    And I have a scored report named "Scored Report"
    And I have a published report named "Active Report"
    When I go to the reports page
    Then I should not see "Empty Report"
    And I should see "Active Report"
    When I go to my reports page
    Then I should see "Empty Report"
    And I should see "Unscored Report"
    And I should see "Scored Report"
    And I should see "Active Report"

  Scenario: View Report name and Description on the report page
    Given I am signed in
    And I have the following published report:
      | name      | description                |
      | My Report | I made this because I care |
    When I go to my reports page
    And I follow "My Report"
    Then I should see "I made this because I care"
