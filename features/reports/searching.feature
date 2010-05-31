Feature: Report Searching
  In order to find a report of interest
  As a user
  I want to search reports

  Scenario: User searches for and views a specific report
    Given a published report named "Zach's Views"
    And 30 published reports
    When I go to the reports page
    Then I should not see "Zach's Views"

    When I fill in "Search" with "Views"
    And I press "Search" within "#content"
    And I should see "Zach's Views"

  Scenario: User searches for and doesn't find a reports
    Given 30 published reports
    When I go to the reports page
    Then I should see "Reports"
    And I fill in "Search" with "smelly roses"
    And I press "Search" within "#content"
    Then I should see "No Reports Found - Try again?"

  Scenario: Search excludes unpublished reports
    Given a report named "Empty Report"
    And an unscored report named "Unscored Report"
    And a scored report named "Scored Report"
    And a published report named "Active Report"
    When I go to the reports page
    And I fill in "Search" with "Report"
    And I press "Search" within "#content"
    Then I should see "Active Report"
    But I should not see "Empty Report"
    And I should not see "Unscored Report"
    And I should not see "Scored Report"
