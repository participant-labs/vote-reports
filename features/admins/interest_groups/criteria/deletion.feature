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
    And I go to the interest group agenda page for "AARP"
    Then I should not see "Bovine Security Act of 2009"
    When I go to the interest group scores page for "AARP"
    Then I should not see "Piyush Jindal"
    And I should see "No ratings on record for this group"

  Scenario: Report owner deletes an existing amendment criterion
    Given I am signed in as an Admin
    And an interest group named "AARP"
    And a pass-voted, current-congress bill named "USA PATRIOT Reauthorization Act of 2009"
    And an amendment named "Fix this thing" on bill "USA PATRIOT Reauthorization Act of 2009"
    And interest group "AARP" has the following amendment criterion:
      | amendment      | support |
      | Fix this thing | true    |
    When I go to the interest group page for "AARP"
    And I follow "Edit Interest Group"
    And I follow "Edit Agenda"
    And I follow "Remove"
    Then I should see "Successfully deleted amendment from agenda"
    And I should be on the edit interest group page for "AARP"
    When I wait for delayed job to finish
    And I go to the interest group agenda page for "AARP"
    Then I should not see "Fix this thing"
