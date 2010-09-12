Feature: Subject viewing
  In order to view bills and reports related to my subjects of interest
  As a user
  I want to browse subjects

  Background:
    Given a bill named "Bovine Security Act of 2009"
    And bill "Bovine Security Act of 2009" has subject "Cows"

  Scenario: Follow a report related through a bill criterion to its page
    Given a published report named "Active Report"
    And report "Active Report" has the following bill criteria:
      | bill                                    | support |
      | Bovine Security Act of 2009             | true    |
    When I wait for delayed job to finish
    And I go to the subject page for "Cows"
    And I follow "Reports"
    And I follow "Active Report"
    Then I should be on the report page for "Active Report"

  Scenario: Follow a related bill to its page
    When I go to the subject page for "Cows"
    And I follow "Bills"
    And I follow "Bovine Security Act"
    Then I should be on the bill page for "Bovine Security Act of 2009"
