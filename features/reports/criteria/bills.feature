Feature: Adding Bill Criteria to Reports
  In order to inject direct legislative meaning into my report
  As a user
  I want to add bills to my report

  Scenario: User adds a bill to a report
    Given I am signed in
    And a bill named "USA PATRIOT Reauthorization Act of 2009"
    And I have a report named "My report"
    When I go to my report page for "My report"
    And I fill in "Add Bills" with "patriot"
    And I press "Search"
    And I check "Support"
    And I press "Save Bills"
    Then I should see "Successfully updated report."
    And I should be on my report page for "My report"
    And I should see "Support -"
    And I should see "USA PATRIOT Reauthorization Act of 2009"
