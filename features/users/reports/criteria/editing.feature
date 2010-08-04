Feature: Editing Criteria from Reports
  In order to correct mistaken criteria additions
  As a user
  I want to edit criteria from my report

  Background:
    Given I am signed in as "Empact"
    And a bill named "Bovine Security Act of 2009"
    And I have a report named "Active Report"
    And report "Active Report" has the following bill criterion:
      | bill                        | support |
      | Bovine Security Act of 2009 | true    |

  Scenario: Non-owner edits an existing bill criterion
    Given I am signed in as "Johnny"
    When I go to the report page for "Active Report"
    Then I should not see "Edit Report"
    When I go to the edit bills page for the report "Active Report"
    Then I should see "You may not access this page"
    And I should be on the reports page for "Empact"

  Scenario: Report owner adds an explanatory url to an existing bill criterion
    Given I have an unlisted report named "Target Report"
    When I go to my report page for "Active Report"
    And I follow "Agenda"
    Then I should see "Bovine Security Act of 2009"
    When I go to the edit page for my report "Active Report"
    And I follow "Edit Agenda"
    And I fill in "Explanatory Link" with "http://example.com/reports/empact/target-report"
    And I press "Save Agenda"
    Then I should see "Successfully updated report"
    And I should be on my report page for "Active Report"
    And I follow "Agenda"
    When I follow "Support"
    Then I should be on my report page for "Target Report"

  @wip
  Scenario: Report owner adds a bad explanatory url to an existing bill criterion
    When I go to my report page for "Active Report"
    And I follow "Edit Agenda"
    And I fill in "Explanatory Link" with "http://foo/bar/baz"
    And I press "Save Agenda"
    Then I should not see "Successfully updated report"
    And I should be on the edit report bills page for "Active Report"
    And I should see "Url http://foo/bar/baz is invalid"
