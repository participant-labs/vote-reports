Feature: Browsing Politicians
  In order to find politician info
  As a user
  I want to browse politician info

  @homepagey
  Scenario: Navigating to politicians from the sidebar
    When I go to the home page
    And I follow "Politicians"
    Then I should be on the politicians page

  Scenario: Browsing to a Politician from the Politicians Page
    Given the following in-office politician records:
      | name      | gov_track_id |
      | Ron Wyden | 300100       |
      | Bob Barr  |              |
    When I go to the politicians page
    And I follow "Ron Wyden"
    Then I should be on the politician page for "Ron Wyden"

  Scenario Outline: Viewing representative terms from the Politicians Page
    Given the following politician records:
      | name      | gov_track_id |
      | Ron Wyden | 300100       |
    And the following representative terms for politician "Ron Wyden":
      | congressional_district   | state   | party   |
      | <congressional_district> | <state> | <party> |
    When I go to the politician page for "Ron Wyden"
    Then I should see "Political History"
    And I should see "<description>"
    And I should see "Rep. Ron Wyden (<state>)"

  Examples:
    | congressional_district | state | party      | party_abbrev | description |
    | 3        | IA    | Republican | R            | Representative for the 3rd congressional district of Iowa; Republican |
    | 0        | TX    | Republican | R            | Representative for the at-large congressional district of Texas; Republican |
    | 3        | IA    |            | I            | Representative for the 3rd congressional district of Iowa |

  Scenario: Viewing senate terms from the Politicians Page
    Given the following politician records:
      | first_name | last_name   |
      | Ron        | Wyden       |
    And the following senate terms for politician "Ron Wyden":
      | senate_class | state | party      |
      | 3            | IA    | Republican |
    When I go to the politician page for "Ron Wyden"
    Then I should see "Political History"
    And I should see "Senator for Iowa; Republican"
    And I should see "Sen. Ron Wyden (IA)"

  Scenario: Viewing presidential terms from the Politicians Page
    Given the following politician records:
      | first_name | last_name   | gov_track_id |
      | Ron        | Wyden       | 300100       |
    And the following presidential terms for politician "Ron Wyden":
      | party      |
      | Republican |
    When I go to the politician page for "Ron Wyden"
    Then I should see "Political History"
    And I should see "President of these United States; Republican"
    And I should see "Pres. Ron Wyden"
