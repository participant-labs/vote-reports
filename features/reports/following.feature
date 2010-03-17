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

  Scenario: Logged-in user follows a report
    Given a published report named "Published Report"
    And I am signed in as "Empact"
    When I go to the report page for "Published Report"
    And I press "Follow this Report"
    Then I should see "You are now following this report"
    And I should be on the report page for "Published Report"
    And I should see "You're following this report"

  Scenario: Report creator can't follow their own report
    Given I am signed in
    And I have a published report named "Published Report"
    And I go to the report page for "Published Report"
    Then I should not see "You're following this report"
    And I should not see "Following reports gives you access to special report features and updates."
