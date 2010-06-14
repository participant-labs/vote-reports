Feature: Personal Report
  In order to stay know who to vote for
  As a user
  I want to create an unlisted report based on those reports I agree with

  Scenario: User follows one report, whose scores are displayed on the personal report
    Given a published report named "A Certain Published Report"
    And I am signed in
    And I am following report "A Certain Published Report"
    When I go to my profile page
    Then I should see "Personalized Report"

  Scenario: User follows multiple reports, whose scores are displayed on the personal report
    Given I am signed in
    And a published report named "A Certain Published Report"
    And a published report named "Another Published Report"
    And I am following report "A Certain Published Report"
    And I am following report "Another Published Report"
    When I go to my profile page
    Then I should see "Personalized Report"
