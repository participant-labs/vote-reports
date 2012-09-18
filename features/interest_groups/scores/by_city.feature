Feature: Browsing Report Scores by City
  In order to find report scores for my representative
  As a user
  I want to view a report's scores for reps of a given city

  Background:
    Given an interest group named "Sierra Club"
    And the following politician records:
      | name                  |
      | Michael Burgess       |
      | J. Kerrey             |
      | John Cornyn           |
      | Kay Hutchison         |
      | Connie Mack           |
      | Neil Abercrombie      |
    And the following representative term records:
      | name                  | state | congressional_district |
      | Michael Burgess       | TX    | 26       |
      | J. Kerrey             | TX    | 11       |
      | Kay Hutchison         | TX    | 9        |
      | Neil Abercrombie      | NY    | 7        |
    And the following senate term records:
      | name                  | state |
      | John Cornyn           | TX    |
      | Connie Mack           | OH    |
    And the following congressional district zip code records:
      | state | congressional_district | zip_code |
      | TX    | 26       | 75028    |
      | TX    | 11       | 75028    |
      | TX    | 11       | 78704    |
      | NY    | 7        | 11111    |
    And the following location records:
      | zip_code | city         | state |
      | 75028    | LEWISVILLE   | TX    |
      | 11111    | LEWISVILLE   | TX    |
    And interest group "Sierra Club" has the following ratings:
      | report    | politician          | rating |
      | 2008      | Michael Burgess     | 0      |
      | 2008      | J. Kerrey           | 30     |
      | 2008      | John Cornyn         | 20     |
      | 2008      | Kay Hutchison       | 25     |
      | 2008      | Connie Mack         | 80     |
      | 2008      | Neil Abercrombie    | 100    |
      | Fall 2003 | Michael Burgess     | 100    |
      | Fall 2003 | J. Kerrey           | 30     |
      | Fall 2003 | John Cornyn         | 0      |
      | Fall 2003 | Kay Hutchison       | 70     |
      | Fall 2003 | Connie Mack         | 12     |
      | Fall 2003 | Neil Abercrombie    | 100    |
    And the scores for interest group "Sierra Club" are calculated

  Scenario: When unscoped, report scores should be proper and complete
    When I go to the interest group scores page for "Sierra Club"
    Then I should see the following scores:
      | politician           | score |
      | Michael Burgess      | 42    |
      | J. Kerrey            | 30    |
      | John Cornyn          | 12    |
      | Kay Hutchison        | 44    |
      | Connie Mack          | 51    |
      | Neil Abercrombie     | 100   |

  Scenario Outline: Narrow report results to those within a certain zip code
    When I go to the interest group scores page for "Sierra Club"
    And I fill in "Reps representing" with "<address>"
    And I press "Show Reps"
    Then I should see the following scores:
      | politician           | score |
      | Michael Burgess      | 42    |
      | J. Kerrey            | 30    |
      | John Cornyn          | 12    |
    But I should not see "Connie Mack"
    And I should not see "Kay Hutchison"
    And I should not see "Neil Abercrombie"

  Examples:
    | address |
    | Lewisville, TX |
    | lewisville, tx |
