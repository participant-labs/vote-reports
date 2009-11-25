Feature: Browsing Reports
  In order to find interesting reports
  As a user
  I want to browse reports

  Scenario: Browse excludes empty reports
    Given a report named "Empty Report"
    And a published report named "Active Report"
    When I go to the reports page
    Then I should not see "Empty Report"
    And I should see "Active Report"

  Scenario: My Reports doesn't exclude empty reports
    Given I am signed in
    Given a report by me named "Empty Report"
    And a published report by me named "Active Report"
    When I go to the reports page
    Then I should not see "Empty Report"
    And I should see "Active Report"
    When I go to my reports page
    Then I should see "Empty Report"
    And I should see "Active Report"
