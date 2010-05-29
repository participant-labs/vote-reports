Feature: Adding Reports to Causes
  In order to compose a causes scores
  As an admin
  I want to add reports to causes

  Scenario: Add report to cause
    Given an admin named "Admin"
    And a published report named "Brady Campaign to Prevent Gun Violence"
    And a cause named "Gun Control"
    When I log in as "Admin/password"
    And I go to the cause page for "Gun Control"
    And I follow "Add Reports"
    And I fill in "Search Reports" with "Brady"
    And I press "Search" within "#content"
    Then I should see "Brady Campaign to Prevent Gun Violence"
    And I check "Support"
    And I press "Save"
    Then I should see "Successfully added reports to cause"
    And I should be on the cause page for "Gun Control"
