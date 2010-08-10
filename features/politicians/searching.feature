Feature: Browsing Politicians
  In order to find my own representative, or a representative of interest
  As a user
  I want to search politicians

  Background:
    Given the following politician records:
      | name                  |
      | Michael Burgess       |
      | J. Kerrey             |
      | John Cornyn           |
      | Kay Hutchison         |
      | Connie Mack           |
      | Neil Abercrombie      |
    And the following representative term records:
      | name                  | state | congressional_district | in_office |
      | Michael Burgess       | TX    | 26       | true      |
      | J. Kerrey             | TX    | 11       | false     |
      | Neil Abercrombie      | NY    | 7        | true      |
    And the following senate term records:
      | name                  | state | in_office |
      | John Cornyn           | TX    | true      |
      | Kay Hutchison         | TX    | false     |
      | Connie Mack           | OH    | false     |
    And the following congressional district zip code records:
      | state | congressional_district | zip_code |
      | TX    | 26       | 75028    |
      | TX    | 11       | 78704    |
      | NY    | 7        | 11111    |

  Scenario: Browsing to a Politician from the Politicians Page
    When I go to the politicians page
    And I fill in "Reps from" with "75028"
    And I uncheck "In Office"
    And I press "Show Reps"
    Then I should see "Rep. Burgess"
    And I should see "Sen. Hutchison"
    And I should see "Sen. Cornyn"
    But I should not see "Rep. Kerrey"
    And I should not see "Sen. Mack"
    And I should not see "Rep. Abercrombie"

  Scenario: User views only in-office reps
    When I go to the politicians page
    When I check "In Office"
    And I press "Show Reps"
    Then I should see "Rep. Burgess"
    And I should see "Rep. Abercrombie"
    And I should see "Sen. Cornyn"
    But I should not see "Rep. Kerrey"
    And I should not see "Sen. Hutchison"
    And I should not see "Sen. Mack"
    When I fill in "Reps from" with "TX"
    And I press "Show Reps"
    Then I should see "Rep. Burgess"
    And I should see "Sen. Cornyn"
    And I should not see "Rep. Abercrombie"
    But I should not see "Rep. Kerrey"
    And I should not see "Sen. Hutchison"
    And I should not see "Sen. Mack"
