Feature: Browsing the Guide
  In order to summarize my representatives behavior and how they relate to mine
  As a voter
  I want to navigate the guides location/subject/politician score interface

  @javascript
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
    And my location is assured to "TX-26"

    When I go to the new guide page
    And I fill in "Your Location" with "75028"
    And I press "Continue"
    Then I should see "Michael Burgess"
    And I should see "John Cornyn"
    But I should not see "Kerrey"
    And I should not see "Abercrombie"
