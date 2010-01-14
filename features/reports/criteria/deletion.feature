Feature: Deleting Criteria from Reports
  In order to correct mistaken criteria additions
  As a user
  I want to delete criteria from my report

  Scenario: Non-owner deletes an existing bill criterion
    Given a bill named "Bovine Security Act of 2009"
    And a report named "Active Report"
    And report "Active Report" has the following bill criterion:
      | bill                        | support |
      | Bovine Security Act of 2009 | true    |
    And I am signed in
    When I go to the report page for "Active Report"
    Then I should not see "Delete 'Bovine Security Act of 2009' criterion"

  Scenario: Report owner deletes an existing bill criterion
    Given I am signed in
    And a bill named "Bovine Security Act of 2009"
    And I have a report named "Active Report"
    And report "Active Report" has the following bill criterion:
      | bill                        | support |
      | Bovine Security Act of 2009 | true    |
    When I go to my report page for "Active Report"
    And I press "delete"
    Then I should see "Successfully deleted report criterion"
    And I should be on the report page for "Active Report"
    And I should not see "Bovine Security Act of 2009"
