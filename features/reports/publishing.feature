Feature: Browsing Reports
  In order to make my report visible to the world
  As a user
  I want to publish my report

  Background:
    Given I am signed in

  Scenario: User can't publish an empty report
    Given I have an empty report named "My Report"
    When I go to my report page for "My Report"
    Then I should not see the button "Publish this Report"

  Scenario: User can't publish an unscored report
    Given I have an unscored report named "My Report"
    When I go to my report page for "My Report"
    Then I should not see the button "Publish this Report"

  Scenario: User publishes a scored report
    Given I have a scored report named "My Report"
    When I go to my report page for "My Report"
    Then I should see the button "Publish this Report"
    When I press "Publish"
    Then I should see "Successfully published report"

  Scenario: Published report is unpublishable after deleting all criteria
    Given I have a scored report named "My Report"
    When I go to my report page for "My Report"
    Then I should see the button "Publish this Report"
    When I press "Remove this Bill"
    Then I should see "Successfully deleted report criterion"
    And I should not see the button "Publish this Report"

  Scenario: Published report is unpublished on deleting all scores
    Given I have a scored report named "My Report"
    When I go to my report page for "My Report"
    And I press "Publish this Report"
    Then I should see "Successfully published report."
    When I press "Remove this Bill"
    Then I should see "Successfully deleted report criterion"
    And I should not see the button "Publish this Report"
