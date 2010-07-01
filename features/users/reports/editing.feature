Feature: User edits reports
  In order to correct mistakes and maintain consistency
  As a user
  I want to edit my reports

  Background:
    Given I am signed in
    And I have the following published reports:
      | name      | description                |
      | My Report | I made this because I care |

  Scenario: User edits a report and is redirected to the same on success
    When I go to my reports page
    And I follow "My Report"
    And I follow "Edit Report"
    And I fill in "Name" with "My Best Report"
    And I fill in "Description" with "You should read this because I'm awesome"
    And I press "Update Report"
    Then I should see "Successfully updated report."
    And I should be on my report page for "My Best Report"
    And I should see "My Best Report"
    And I should see "You should read this because I'm awesome"
    And I should not see "My Report"
    And I should not see "I made this because I care"

  Scenario: User edits a report description with markdown
    When I go to my reports page
    And I follow "My Report"
    And I follow "Edit Report"
    Then I should see "you can use Markdown"
    When I fill in "Description" with "# You should read this because I'm awesome"
    And I press "Update Report"
    Then I should see "Successfully updated report."
    And I should see "You should read this because I'm awesome"
    And I should not see "# You"
    And I should not see "<h1>"
    When I go to my reports page
    Then I should not see "<h1>"
    And I follow "My Report"
    And I follow "Edit Report"
    Then I should not see "<h1>"
    But I should see "#"

  Scenario: User tries to edit a report to not have a name
    When I go to my reports page
    And I follow "My Report"
    And I follow "Edit Report"
    And I fill in "Name" with ""
    And I press "Update Report"
    Then I should see "Name can't be blank"
    And I should not see "Successfully updated report."

  @javascript
  Scenario: User navigates to the new bill criteria page
    When I go to the edit page for my report "My Report"
    And I follow "Edit Report"
    And I follow "Add Bills to Agenda"
    Then I should see "Declare Your Opposition/Support to Bills"
    And I should see "Search" within "#content"
