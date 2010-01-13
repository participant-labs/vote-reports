Feature: Browsing the Home Page
  In order to find the most important stuff quickly
  As a user
  I want to access reports via the home page

  Scenario: Home page excludes empty reports
    Given a report named "Empty Report"
    When I go to the reports page
    Then I should not see "Empty Report"

  Scenario: Home page excludes published reports
    Given a published report named "Active Report"
    When I go to the reports page
    Then I should see "Active Report"

  Scenario: Home page includes scored reports
    Given a scored report named "Scored Report"
    When I go to the reports page
    Then I should see "Scored Report"
