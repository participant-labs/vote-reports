Feature: Deleting Criteria from Reports
  In order to correct mistaken criteria additions
  As a user
  I want to delete criteria from my report

  @emulate_rails_javascript
  Scenario: Admin deletes an existing bill criterion
    Given I am signed in as an Admin
    And a bill named "Bovine Security Act of 2009"
    And bill "Bovine Security Act of 2009" has the following rolls:
      | roll_type                                            |
      | On Passage                                           |
      | On the Cloture Motion                                |
      | Passage, Objections of the President Notwithstanding |
    And the following politician records:
      | name                  |
      | Piyush Jindal         |
    And bill "Bovine Security Act of 2009" has the following roll votes:
      | politician       | On Passage | On the Cloture Motion | Passage, Objections of the President Notwithstanding |
      | Piyush Jindal    | + | + |   |
    And an interest group named "AARP"
    And interest group "AARP" has the following bill criterion:
      | bill                        | support |
      | Bovine Security Act of 2009 | true    |
    When I go to the interest group page for "AARP"
    And I follow "Edit Interest Group"
    And I follow "Edit Agenda"
    And I follow "Remove"
    Then I should see "Successfully deleted interest group bill criterion"
    And I should be on the edit interest group page for "AARP"

    When I wait for delayed job to finish
    And I go to the interest group page for "AARP"
    And I follow "Agenda"
    Then I should not see "Bovine Security Act of 2009"
    When I go to the interest group page for "AARP"
    And I follow "Scores"
    Then I should not see "Piyush Jindal"
    And I should see "No ratings on record for this group"
