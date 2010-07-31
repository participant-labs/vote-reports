Feature: Scoring Reports
  In order to leverage report data in an actionable form
  As a user
  I want to generate scores for each politician associated with this report's criteria

  Background:
    Given an interest group named "Sierra Club"
    And the following in-office politician records:
      | name                  |
      | Piyush Jindal         |
      | J. Kerrey             |
      | Martin Sabo           |
      | Edward Kaufman        |
      | Connie Mack           |
      | Neil Abercrombie      |
      | Aníbal Acevedo-Vilá   |
      | Julia Carson          |
      | Brad Carson           |
      | Gary Ackerman         |
      | Robert Aderholt       |
      | W. Akin               |

  Scenario: Without Criteria, I should see message noting why no scores exist
    When I go to the interest group page for "Sierra Club"
    And I follow "Scores"
    Then I should see "No ratings on record for this group"

  Scenario: Scores from a single set of numeric ratings
    Given interest group "Sierra Club" has the following ratings:
      | report   | politician            | rating |
      | 2008     | Piyush Jindal         | 0      |
      | 2008     | J. Kerrey             | 30     |
      | 2008     | Martin Sabo           | 20     |
      | 2008     | Edward Kaufman        | 25     |
      | 2008     | Connie Mack           | 80     |
      | 2008     | Neil Abercrombie      | 100    |
    And the scores for interest group "Sierra Club" are calculated
    When I go to the interest group page for "Sierra Club"
    And I follow "Scores"
    Then I should see the following scores:
      | politician           | score |
      | Piyush Jindal        | 0     |
      | J. Kerrey            | 30    |
      | Martin Sabo          | 20    |
      | Edward Kaufman       | 25    |
      | Connie Mack          | 80    |
      | Neil Abercrombie     | 100   |
  
  Scenario: Scores from a multiple sets of numeric ratings combine
    Given interest group "Sierra Club" has the following ratings:
      | report    | politician            | rating |
      | 2008      | Piyush Jindal         | 0      |
      | 2008      | J. Kerrey             | 30     |
      | 2008      | Martin Sabo           | 20     |
      | 2008      | Edward Kaufman        | 25     |
      | 2008      | Connie Mack           | 80     |
      | 2008      | Neil Abercrombie      | 100    |
      | Fall 2003 | Piyush Jindal         | 100    |
      | Fall 2003 | J. Kerrey             | 30     |
      | Fall 2003 | Martin Sabo           | 0      |
      | Fall 2003 | Edward Kaufman        | 70     |
      | Fall 2003 | Connie Mack           | 12     |
      | Fall 2003 | Neil Abercrombie      | 100    |
    And the scores for interest group "Sierra Club" are calculated
    When I go to the interest group page for "Sierra Club"
    And I follow "Scores"
    Then I should see the following scores:
      | politician           | score |
      | Piyush Jindal        | 42    |
      | J. Kerrey            | 30    |
      | Martin Sabo          | 12    |
      | Edward Kaufman       | 44    |
      | Connie Mack          | 51    |
      | Neil Abercrombie     | 100   |