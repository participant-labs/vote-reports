Feature: Report Following
  In order to stay in the loop
  As a user
  I want to follow reports I agree with

  Scenario: Logged-out user follows a report
    Given a published report named "Published Report"
    And I signed up as:
      | username | password |
      | Empact   | password |
    When I go to the report page for "Published Report"
    And I press "Follow this Report"
    And I enter my credentials "Empact/password"
    Then I should see "You are now following this report"
    And I should be on the report page for "Published Report"
    And I should see "You're following this report"

  Scenario: Logged-out report creator follows their own report
    Given I am signed in as "Empact"
    And I have a published report named "Published Report"
    And I sign out
    When I go to the report page for "Published Report"
    And I press "Follow this Report"
    And I enter my credentials "Empact/password"
    Then I should see "You are now following this report"
    And I should be on the report page for "Published Report"
    And I should see "You're following this report"

  Scenario: Logged-in user follows a report
    Given a published report named "Published Report"
    And I am signed in as "Empact"
    When I go to the report page for "Published Report"
    And I press "Follow this Report"
    Then I should see "You are now following this report"
    And I should be on the report page for "Published Report"
    And I should see "You're following this report"

  Scenario: Followed reports show up on user page, not reports page
    Given a published report named "A Certain Published Report"
    And I am signed in as "Empact"
    And user "Empact" is following report "A Certain Published Report"
    When I go to my profile page
    Then I should see "A Certain Published Report"
    When I go to my reports page
    Then I should not see "A Certain Published Report"

  Scenario: Report creator can follow their own report
    Given I am signed in
    And I have a published report named "Published Report"
    And I go to the report page for "Published Report"
    And I press "Follow this Report"
    Then I should see "You are now following this report"
    And I should be on the report page for "Published Report"
    And I should see "You're following this report"
