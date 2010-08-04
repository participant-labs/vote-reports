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

  @emulate_rails_javascript
  Scenario: Report owner deletes an existing bill criterion
    Given I am signed in
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
    And I have a report named "Active Report"
    And report "Active Report" has the following bill criterion:
      | bill                        | support |
      | Bovine Security Act of 2009 | true    |
    When I go to my report page for "Active Report"
    And I follow "Edit Report"
    And I follow "Edit Agenda"
    And I follow "Remove"
    Then I should see "Successfully deleted report criterion"
    And I should be on the edit page for my report "Active Report"

    When I wait for delayed job to finish
    And I go to my report page for "Active Report"
    And I follow "Agenda"
    Then I should not see "Bovine Security Act of 2009"
    When I go to my report page for "Active Report"
    And I follow "Scores"
    Then I should not see "Piyush Jindal"
    And I should see "No scores yet, as this report has no criteria to judge representatives by."

  Scenario: Report owner deletes an existing amendment criterion
    Given I am signed in
    And I have a report named "Active Report"
    And a pass-voted, current-congress bill named "USA PATRIOT Reauthorization Act of 2009"
    And an amendment named "Fix this thing" on bill "USA PATRIOT Reauthorization Act of 2009"
    And report "Active Report" has the following amendment criterion:
      | amendment      | support |
      | Fix this thing | true    |
    When I go to my report page for "Active Report"
    And I follow "Edit Report"
    And I follow "Edit Agenda"
    And I follow "Remove"
    Then I should see "Successfully deleted amendment from report agenda"
    And I should be on the edit page for my report "Active Report"
    When I wait for delayed job to finish
    And I go to my report page for "Active Report"
    And I follow "Agenda"
    Then I should not see "Fix this thing"
