Feature: Bill viewing
  In order to view specific bills and related content
  As a user
  I want to browse bills

  Scenario: User searches for and views a specific bill
    Given a bill named "USA PATRIOT Reauthorization Act of 2009"
    And 30 recent bills
    When I go to the bills page
    Then I should not see "USA PATRIOT Reauthorization Act of 2009"

    When I fill in "Search" with "Patriot Act"
    And I press "Search"
    And I should see "USA PATRIOT Reauthorization Act of 2009"

  Scenario: User searches for and doesn't find a bills
    When I go to the bills page
    Then I should see "Recent Bills"
    And I fill in "Search" with "smelly roses"
    And I press "Search"
    Then I should see "Matching Bills"
    Then I should see "No matching bills found..."

  Scenario: User browses from a current congress bill to OpenCongress
    Given a current-congress bill named "USA PATRIOT Reauthorization Act of 2009"
    When I go to the bill page for "USA PATRIOT Reauthorization Act of 2009"
    Then I should see "View on OpenCongress"
