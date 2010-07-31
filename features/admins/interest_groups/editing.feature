Feature: Editing Interest Group
  In order to correct bad, oudated info
  As an admin
  I want to edit interest groups

  Background:
    Given an interest group named "AARP"
    And I am signed in as an Admin

  Scenario: Admin edits a report and is redirected to the same on success
    When I go to the interest group page for "AARP"
    And I follow "Edit Interest Group"
    And I fill in "Name" with "American Association of Retired Persons"
    And I fill in "Description" with "We care about retired folks"
    And I press "Update Interest Group"
    Then I should see "Successfully updated interest group"
    And I should be on the interest group page for "American Association of Retired Persons"
    And I should see "American Association of Retired Persons"
    And I should see "We care about retired folks"
    And I should not see "AARP"
