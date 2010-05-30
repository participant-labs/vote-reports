Feature: Browsing the Guide
  In order to summarize my representatives behavior and how they relate to mine
  As a voter
  I want to navigate the guides location/subject/politician score interface

  Scenario: Entering a location
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

    When I go to the guide page
    And I fill in "representing" with "75028"
    And I press "Show Reps"
    Then I should see "Michael Burgess"
    And I should see "John Cornyn"
    But I should not see "J. Kerrey"
    And I should not see "Neil Abercrombie"
