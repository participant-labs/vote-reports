Feature: Report Searching
  In order to find a report of interest
  As a user
  I want to search reports

  Scenario: User searches for and views a specific report
    Given a published report named "My Views"
    And 30 published reports
    When I go to the reports page
    Then I should not see "My Views"

    When I fill in "Search" with "Views"
    And I press "Search"
    And I should see "My Views"

  Scenario: User searches for and doesn't find a reports
    Given 30 published reports
    When I go to the reports page
    Then I should see "Recent Reports"
    And I fill in "Search" with "smelly roses"
    And I press "Search"
    Then I should see "Matching Reports"
    Then I should see "No reports found..."
