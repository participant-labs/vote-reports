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
