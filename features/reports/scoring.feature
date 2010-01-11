Feature: Scoring Reports
  In order to leverage report data in an actionable form
  As a user
  I want to generate scores for each politician associated with this report's criteria

  Scenario: Bill Criteria report generates scores
    Given I have a report named "Active Report"
    And an un-voted, current-congress bill named "Bovine Security Act of 2009"
    And report "Active Report" has the following bill criteria:
      | bill                        | support |
      | Bovine Security Act of 2009 | true    |
    And the following politician records:
      | name           |
      | Michael Jordan |
      | Tiger Woods    |
      | Bill Cosby     |
      | George Foreman |
    And bill "Bovine Security Act of 2009" has the following votes:
      | politician     | vote |
      | Michael Jordan | +    |
      | Tiger Woods    | P    |
      | Bill Cosby     | 0    |
      | George Foreman | -    |
    When I go to my report page for "Active Report"
    Then I should see "Michael Jordan" has the score "100"
    And I should see "Tiger Woods" has the score "0"
    And I should see "Bill Cosby" has the score "0"
    And I should see "George Foreman" has the score "0"
