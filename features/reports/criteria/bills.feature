Feature: Adding Bill Criteria to Reports
  In order to inject direct legislative meaning into my report
  As a user
  I want to add bills to my report

  Background:
    Given I am signed in
    And I have a report named "My report"
    When I go to my report page for "My report"

  Scenario Outline: User adds a bill to a report
    Given <bill type> named "USA PATRIOT Reauthorization Act of 2009"
    When I fill in "Add Bills" with "patriot"
    And I press "Search"
    Then I should see "You searched for: patriot"
    When I check "Support"
    And I press "Save Bills"
    Then I should see "Successfully updated report."
    And I should be on my report page for "My report"
    And I should see "Support -"
    And I should see "USA PATRIOT Reauthorization Act of 2009"

  Examples:
    | bill type                          |
    | a voted, current-congress bill     |
    | an un-voted, current-congress bill |
    | a voted, previous-congress bill    |

  Scenario: Search should not return an unvoted bill from a previous congress
    Given an un-voted, previous-congress bill named "USA PATRIOT Reauthorization Act of 2009"
    When I fill in "Add Bills" with "patriot"
    And I press "Search"
    Then I should see "You searched for: patriot"
    And I should not see "USA PATRIOT Reauthorization Act of 2009"
    And I should see "No bills found"
    When I follow "Back"
    Then I should be on my report page for "My report"