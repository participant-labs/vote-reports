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
      | name                  | state | congressional_district | in_office |
      | Michael Burgess       | TX    | 26       | true      |
      | J. Kerrey             | TX    | 11       | false     |
      | Neil Abercrombie      | NY    | 7        | true      |
    And the following senate term records:
      | name                  | state | in_office |
      | John Cornyn           | TX    | true      |
      | Kay Hutchison         | TX    | false     |
      | Connie Mack           | OH    | false     |
    And my location is assured to "TX-26"

    When I go to the new guide page
    And I fill in "Your Location" with "75028"
    And I press "Set"
    Then I should see "Rep. Burgess"
    And I should see "Sen. Cornyn"
    But I should not see "Kerrey"
    And I should not see "Abercrombie"
