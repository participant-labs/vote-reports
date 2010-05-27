Feature: Editing Causes
  In order to adjust causes to new circumstances
  As an admin
  I want to edit causes

  Scenario: Editing a Cause name
    Given a cause named "Trade is Awesome"
    And an admin named "Admin"
    When I log in as "Admin/password"
    And I go to the cause page for "Trade is Awesome"
    And I follow "Edit Cause"
    And I fill in "Name" with "International Trade is Awesome"
    And I press "Update Cause"
    Then I should see "Successfully updated Cause"
    And I should be on the cause page for "International Trade is Awesome"
