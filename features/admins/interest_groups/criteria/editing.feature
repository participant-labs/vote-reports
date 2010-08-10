Feature: Editing Criteria from Reports
  In order to correct mistaken criteria additions
  As a user
  I want to edit criteria from my report

  Background:
    Given I am signed in as an Admin
    And an interest group named "AARP"
    And a bill named "Bovine Security Act of 2009"
    And interest group "AARP" has the following bill criterion:
      | bill                        | support |
      | Bovine Security Act of 2009 | true    |

  Scenario: Report owner adds an explanatory url to an existing bill criterion
    Given an interest group named "Target"
    When I go to the interest group agenda page for "AARP"
    Then I should see "Bovine Security Act of 2009"
    When I go to the edit interest group page for "AARP"
    And I follow "Edit Agenda"
    And I fill in "Explanatory Link" with "http://example.com/interest_groups/target"
    And I press "Save Agenda"
    Then I should see "Successfully updated interest group"
    And I should be on the interest group page for "AARP"
    When I go to the interest group agenda page for "AARP"
    And I follow "Support"
    Then I should be on the interest group page for "Target"

  @wip
  Scenario: Report owner adds a bad explanatory url to an existing bill criterion
    When I go to the edit interest group page for "AARP"
    And I follow "Edit Agenda"
    And I fill in "Explanatory Link" with "http://foo/bar/baz"
    And I press "Save Agenda"
    Then I should not see "Successfully updated report"
    And I should be on the edit interest group page for "AARP"
    And I should see "Url http://foo/bar/baz is invalid"
