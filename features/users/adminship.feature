Feature: Adminship
  In order to add permissions to users
  An admin
  Should be able to promote users to the same

  Scenario: Admin promotes user
    Given an admin named "Admin"
    And a user named "User"
    When I log in as "Admin/password"
    And I go to the edit user page for "User"
    And I press "Promote to Admin"
    Then I should see "Successfully promoted to Admin"
    And I should see "Promoted to Admin"

  Scenario: Admin demotes user
    Given an admin named "Admin"
    And an admin named "OtherAdmin"
    When I log in as "Admin/password"
    And I go to the edit user page for "OtherAdmin"
    And I press "Revoke Admin Status"
    Then I should see "Successfully revoked Admin"
    And I should not see "Promoted to Admin"
