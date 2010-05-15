Feature: Browsing Reports
  In order to find interesting reports
  As a user
  I want to browse reports

  Background:
    Given I am signed in as "Empact"
    And I have a report named "Empty Report"
    And I have an unscored report named "Unscored Report"
    And I have a scored report named "Scored Report"
    And I have a personal report named "Personal Report"
    And I have a published report named "Active Report"

  Scenario: Browse excludes unpublished reports
    When I go to the reports page
    Then I should see "Active Report"
    But I should not see "Empty Report"
    And I should not see "Unscored Report"
    And I should not see "Scored Report"
    And I should not see "Personal Report"

  Scenario: User reports view excludes unpublished reports
    When I go to my reports page
    Then I should see "Published Reports"
    And I should see "Active Report"
    But I should not see "Empty Report"
    And I should not see "Unscored Report"
    And I should not see "Scored Report"
    And I should not see "Personal Report"
    When I follow "View All Reports"
    Then I should be on my profile page

  Scenario: My Reports doesn't exclude empty reports
    When I go to my profile page
    Then I should see "Empty Report"
    And I should see "Unscored Report"
    And I should see "Scored Report"
    And I should see "Personal Report"
    And I should see "Active Report"

  Scenario: Other users can't access My Reports
    Given I am signed in as "NotEmpact"
    When I go to the user page for "Empact"
    Then I should be on the reports page for "Empact"
