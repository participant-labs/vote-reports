Feature: Browsing Politicians
  In order to find politician info
  As a user
  I want to browse politician info

  Scenario: Navigating to politicians from the sidebar
    When I go to the home page
    And I follow "Politicians"
    Then I should be on the politicians page

  Scenario: Browsing to a Politician from the Politicians Page
    Given the following politician records:
      | name      | gov_track_id |
      | Ron Wyden | 300100       |
      | Bob Barr  |              |
    When I go to the politicians page
    And I follow "Ron Wyden"
    Then I should be on the politician page for "Ron Wyden"

  Scenario: Viewing representative terms from the Politicians Page
    Given the following politician records:
      | name      | gov_track_id |
      | Ron Wyden | 300100       |
    And the following representative terms for politician "Ron Wyden":
      | district | state |
      | 3        | IA    |
    When I go to the politician page for "Ron Wyden"
    Then I should see "Terms in Congress"
    And I should see "representing the 3rd district of Iowa"

  Scenario: Viewing senate terms from the Politicians Page
    Given the following politician records:
      | first_name | last_name   | gov_track_id | district    |
      | Ron        | Wyden       | 300100       | Senior Seat |
    And the following senate terms for politician "Ron Wyden":
      | senate_class | state |
      | 3            | IA    |
    When I go to the politician page for "Ron Wyden"
    Then I should see "Terms in Congress"
    And I should see "the Senior Seat for Iowa"

  Scenario: Viewing supported bills from the Politicians Page
    Given I have a report named "Active Report"
    And an un-voted, current-congress bill named "Bovine Security Act of 2009"
    And an un-voted, current-congress bill named "USA PATRIOT Reauthorization Act of 2009"
    And the following politician records:
      | name                  |
      | Piyush Jindal         |
    And bill "Bovine Security Act of 2009" has the following votes:
      | politician     | vote |
      | Piyush Jindal  | +    |
    When I go to the politician page for "Piyush Jindal"
    Then I should see "Supported Bills"
    And I should see "Bovine Security Act of 2009"

    Given bill "USA PATRIOT Reauthorization Act of 2009" has the following votes:
      | politician     | vote |
      | Piyush Jindal  | -    |
    When I go to the politician page for "Piyush Jindal"
    Then I should see "Opposed Bills"
    And I should see "USA PATRIOT Reauthorization Act of 2009"
