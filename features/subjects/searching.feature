Feature: Subject Searching
  In order to find a subject of interest
  As a user
  I want to search subjects

  Scenario: User searches for and views a specific bill
    Given 79 subjects with 2 report bills each
    And 3 report bills with subject "Taxation"
    And 4 bills with subject "Cows"
    And 1 report bills with subject "Marijuana"
    When I go to the subjects page
    Then I should see "Taxation"
    But I should not see "Cows"
    And I should not see "Marijuana"

    When I fill in "Search" with "Marijuana"
    And I press "Search" within "#content"
    And I should see "Marijuana"
    And I should not see "Taxation"

  Scenario: User searches for and doesn't find a bills
    Given 25 subjects with 1 report bill each
    When I go to the subjects page
    Then I should see "Popular Subjects"
    And I fill in "Search" with "smelly roses"
    And I press "Search" within "#content"
    Then I should see "Matching Subjects"
    Then I should see "No matching subjects found..."
