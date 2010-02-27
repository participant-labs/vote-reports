Feature: Subject Searching
  In order to find a subject of interest
  As a user
  I want to search subjects

  Scenario: User searches for and views a specific bill
    Given 30 subjects with 5 bills each
    And 20 bills with subject "Taxation"
    And 2 bills with subject "Marijuana"
    When I go to the subjects page
    Then I should see "Taxation"
    And I should not see "Marijuana"

    When I fill in "Search" with "Marijuana"
    And I press "Search"
    And I should see "Marijuana"
    And I should not see "Taxation"

  Scenario: User searches for and doesn't find a bills
    Given 25 subjects with 1 bill each
    When I go to the subjects page
    Then I should see "Popular Subjects"
    And I fill in "Search" with "smelly roses"
    And I press "Search"
    Then I should see "Matching Subjects"
    Then I should see "No matching subjects found..."
