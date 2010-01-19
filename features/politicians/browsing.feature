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

  Scenario Outline: Viewing representative terms from the Politicians Page
    Given the following politician records:
      | name      | gov_track_id |
      | Ron Wyden | 300100       |
    And the following representative terms for politician "Ron Wyden":
      | district   | state   | party   |
      | <district> | <state> | <party> |
    When I go to the politician page for "Ron Wyden"
    Then I should see "Terms in Congress"
    And I should see "<description>"
    And I should see "Ron Wyden  (<party_abbrev> - <state>)"

  Examples:
    | district | state | party      | party_abbrev | description |
    | 3        | IA    | Republican | R            | Representative for the 3rd district of Iowa; Republican |
    | 0        | TX    | Republican | R            | Representative for the at-large district of Texas; Republican |
    |          | TX    | Republican | R            | Representative for Texas; Republican |
    |          | TX    |            | I            | Representative for Texas |
    | 3        | IA    |            | I            | Representative for the 3rd district of Iowa |

  Scenario: Viewing senate terms from the Politicians Page
    Given the following politician records:
      | first_name | last_name   | gov_track_id | district    |
      | Ron        | Wyden       | 300100       | Senior Seat |
    And the following senate terms for politician "Ron Wyden":
      | senate_class | state | party      |
      | 3            | IA    | Republican |
    When I go to the politician page for "Ron Wyden"
    Then I should see "Terms in Congress"
    And I should see "Senator for Iowa; Republican"

  Scenario: Viewing supported bills from the Politicians Page
    Given I have a report named "Active Report"
    And an un-voted, current-congress bill named "Bovine Security Act of 2009"
    And an un-voted, current-congress bill named "USA PATRIOT Reauthorization Act of 2009"
    And the following politician records:
      | name                  |
      | Piyush Jindal         |
      | Ron Wyden             |
    And bill "Bovine Security Act of 2009" has the following rolls:
      | roll_type                                          |
      | On Passage                                         |
      | On the Cloture Motion                              |
      | On Agreeing to the Amendments en bloc, as modified |
    And bill "Bovine Security Act of 2009" has the following roll votes:
      | politician       | On Passage | On the Cloture Motion | On Agreeing to the Amendments en bloc, as modified |
      | Piyush Jindal    | + | + | - |
    When I go to the politician page for "Piyush Jindal"
    Then I should see "Supported Bills"
    And I should see "Bovine Security Act of 2009"
    And I should see "We have no record of opposition from this politician"

    Given bill "USA PATRIOT Reauthorization Act of 2009" has the following rolls:
      | roll_type                                          |
      | On Passage                                         |
      | On the Cloture Motion                              |
      | On Agreeing to the Amendments en bloc, as modified |
    And bill "USA PATRIOT Reauthorization Act of 2009" has the following roll votes:
      | politician   | On Passage | On the Cloture Motion | On Agreeing to the Amendments en bloc, as modified |
      | Ron Wyden    | - | + | - |
    Given bill "USA PATRIOT Reauthorization Act of 2009" has the following passage votes:
      | politician | vote |
      | Ron Wyden  | -    |
    When I go to the politician page for "Ron Wyden"
    Then I should see "Opposed Bills"
    And I should see "USA PATRIOT Reauthorization Act of 2009"
    And I should not see "We have no record of opposition from this politician"
    And I should not see "We have no record of support from this politician"
