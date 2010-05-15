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
      | name                  | state | district | in_office |
      | Michael Burgess       | TX    | 26       | true      |
      | J. Kerrey             | TX    | 11       | false     |
      | Neil Abercrombie      | NY    | 7        | true      |
    And the following senate term records:
      | name                  | state | in_office |
      | John Cornyn           | TX    | true      |
      | Kay Hutchison         | TX    | false     |
      | Connie Mack           | OH    | false     |
    And the following district zip code records:
      | state | district | zip_code |
      | TX    | 26       | 75028    |
      | TX    | 11       | 78704    |
      | NY    | 7        | 11111    |

  Scenario: Browsing to a Politician from the Politicians Page
    When I go to the politicians page
    And I fill in "From" with "75028"
    And I uncheck "In Office Only"
    And I press "Show Reps"
    Then I should see "Michael Burgess"
    And I should see "Kay Hutchison"
    And I should see "John Cornyn"
    But I should not see "J. Kerrey"
    And I should not see "Connie Mack"
    And I should not see "Neil Abercrombie"

  Scenario: User views only in-office reps
    When I go to the politicians page
    When I check "In Office Only"
    And I press "Show Reps"
    Then I should see "Michael Burgess"
    And I should see "Neil Abercrombie"
    And I should see "John Cornyn"
    But I should not see "J. Kerrey"
    And I should not see "Kay Hutchison"
    And I should not see "Connie Mack"
    When I fill in "From" with "TX"
    And I press "Show Reps"
    Then I should see "Michael Burgess"
    And I should see "John Cornyn"
    And I should not see "Neil Abercrombie"
    But I should not see "J. Kerrey"
    And I should not see "Kay Hutchison"
    And I should not see "Connie Mack"
