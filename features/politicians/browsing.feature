Feature: Browsing Politicians
  In order to find politician info
  As a user
  I want to browse politician info

  Scenario: Navigating to politicians from the sidebar
    When I go to the home page
    And I follow "Politicians"
    Then I should be on the politicians page

  Scenario: Browsing to a Politician from the Politicians Page
    Given the following politician:
      | first_name | last_name   | gov_track_id |
      | Ron        | Wyden       | 300100       |
    When I go to the politicians page
    Then I should see "Ron Wyden"

    When I follow "Ron Wyden"
    Then I should see "Ron Wyden"
    And I should see "Supported Bills"
    And I should see "Opposed Bills"

  Scenario: Viewing terms from the Politicians Page
    Given the following politician records:
      | first_name | last_name   | gov_track_id |
      | Ron        | Wyden       | 300100       |
    And the following representative terms for "Ron Wyden":
      | district | state |
      | 3        | IA    |
    When I go to the politician page for "Ron Wyden"
    Then I should see "Terms in Congress"
    And I should see "representing the 3rd district of Iowa"
