Feature: Browsing Report Scores by State
  In order to find report scores for my representative
  As a user
  I want to view a report's scores for reps of a given state

  Background:
    Given I have an unlisted report named "Active Report"
    And an un-voted, current-congress bill named "Bovine Security Act of 2009"
    And the following politician records:
      | name                  |
      | Piyush Jindal         |
      | J. Kerrey             |
      | Martin Sabo           |
      | Edward Kaufman        |
      | Connie Mack           |
      | Neil Abercrombie      |
    And the following representative term records:
      | name                  | state | congressional_district |
      | Piyush Jindal         | TX    | 26       |
      | J. Kerrey             | TX    | 11       |
      | Neil Abercrombie      | NY    | 7        |
    And the following senate term records:
      | name                  | state |
      | Martin Sabo           | TX    |
      | Edward Kaufman        | TX    |
      | Connie Mack           | OH    |
    Given the following congressional district zip code records:
      | state | congressional_district | zip_code | plus_4 |
      | TX    | 26       | 75028    |        |
      | TX    | 11       | 75028    | 7      |
      | NY    | 7        | 11111    | 111    |
    And bill "Bovine Security Act of 2009" has the following rolls:
      | roll_type                                            | voted_at     |
      | On Passage                                           | 2.years.ago  |
      | On the Cloture Motion                                | 1.year.ago   |
      | Passage, Objections of the President Notwithstanding | 6.months.ago |
    And bill "Bovine Security Act of 2009" has the following roll votes:
      | politician       | On Passage | On the Cloture Motion | Passage, Objections of the President Notwithstanding |
      | Piyush Jindal    | + | + |   |
      | J. Kerrey        | P | - |   |
      | Martin Sabo      | 0 | + |   |
      | Edward Kaufman   | - |   | + |
      | Connie Mack      |   |   | P |
      | Neil Abercrombie | - |   | - |
    And report "Active Report" has the following bill criterion:
      | bill                        | support |
      | Bovine Security Act of 2009 | true    |
    And I wait for delayed job to finish

  Scenario: When unscoped, report scores should be proper and complete
    When I go to my report scores page for "Active Report"
    Then I should see the following scores:
      | politician           | score |
      | Piyush Jindal        | 100   |
      | J. Kerrey            | 24    |
      | Martin Sabo          | 76    |
      | Edward Kaufman       | 53    |
      | Connie Mack          | 50    |
      | Neil Abercrombie     | 0     |

  Scenario Outline: Narrow report results to those within a certain zip code
    When I go to my report scores page for "Active Report"
    And I fill in "Reps from" with "<location>"
    And I press "Show Reps"
    Then I should see the following scores:
      | politician           | score |
      | Piyush Jindal        | 100   |
      | J. Kerrey            | 24    |
      | Edward Kaufman       | 53    |
      | Martin Sabo          | 76    |
    But I should not see "Connie Mack"
    And I should not see "Neil Abercrombie"

  Examples:
    | location                         |
    | 1115 Oak Drive, Flower Mound, TX |
    | Flower Mound 75028               |
    | 1115 oak drive flower mound      |

  Scenario Outline: Narrow report results to a state through imprecise language
    When I go to my report scores page for "Active Report"
    And I fill in "Reps from" with "<location>"
    And I press "Show Reps"
    Then I should see the following scores:
      | politician           | score |
      | Piyush Jindal        | 100   |
      | Edward Kaufman       | 53    |
      | Martin Sabo          | 76    |
      | J. Kerrey            | 24    |
    But I should not see "Connie Mack"
    And I should not see "Neil Abercrombie"

  Examples:
    | location                         |
    | Flower Mound, TX                 |
