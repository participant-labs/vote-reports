Feature: Bill Searching
  In order to find a bill of interest
  As a user
  I want to search bills

  Scenario: User searches for and views a specific bill
    Given a previous-congress bill named "USA PATRIOT Reauthorization Act of 2009"
    And 30 recent bills
    When I go to the bills page
    Then I should not see "USA PATRIOT Reauthorization Act of 2009"

    When I fill in "Search" with "Patriot Act"
    And I press "Search"
    And I should see "USA PATRIOT Reauthorization Act of 2009"

  Scenario: User searches for and doesn't find a bills
    Given 30 recent bills
    When I go to the bills page
    Then I should see "Recent Bills"
    And I fill in "Search" with "smelly roses"
    And I press "Search"
    Then I should see "Matching Bills"
    And I should see "No bills found..."
