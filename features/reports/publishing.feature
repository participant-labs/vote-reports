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
    And I should see "This report is personal, so it will not show up in lists or searches on this site. However, anyone can access it at this url."
    And I should see "You'll need to add bills to this report in order to publish this report."

  Scenario: User can't publish an unscored report
    Given I have an unscored report named "My Report"
    When I go to my report page for "My Report"
    Then I should not see the button "Publish this Report"
    And I should see "This report is personal, so it will not show up in lists or searches on this site. However, anyone can access it at this url."
    And I should see "None of the added bills have passage roll call votes associated. You'll need to add a voted bill to publish this report."

  Scenario: User publishes a scored report
    Given I have a scored report named "My Report"
    When I go to my report page for "My Report"
    Then I should see the button "Publish this Report"
    When I press "Publish"
    Then I should see "Successfully updated report"
    And I should see "This report is published, so it will show up in lists and searches on this site."

  Scenario: User unpublishes a published report
    Given I have a published report named "My Report"
    When I go to my report page for "My Report"
    Then I should see the button "Unpublish this Report"
    When I press "Unpublish"
    Then I should see "Successfully updated report"
    And I should see "This report is personal, so it will not show up in lists or searches on this site. However, anyone can access it at this url."

  Scenario: Published report is unpublishable after deleting all criteria
    Given I have a scored report named "My Report"
    When I go to my report page for "My Report"
    Then I should see the button "Publish this Report"
    When I remove a bill criterion from report "My Report"
    And I go to my report page for "My Report"
    Then I should not see the button "Publish this Report"
    And I should see "You'll need to add bills to this report in order to publish this report."

  Scenario: Published report is unpublished on deleting all scores
    Given I have a scored report named "My Report"
    When I go to my report page for "My Report"
    And I press "Publish this Report"
    Then I should see "Successfully updated report."
    When I remove a bill criterion from report "My Report"
    And I go to my report page for "My Report"
    Then I should see "Updates have been made to this report, and its scores are being updated."
    When I wait for delayed job to finish
    And I go to my report page for "My Report"
    And I should see "This report is personal, so it will not show up in lists or searches on this site. However, anyone can access it at this url."
    And I should see "You'll need to add bills to this report in order to publish this report."
    And I should not see the button "Publish this Report"
