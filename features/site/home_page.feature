Feature: Browsing the Home Page
  In order to find the most important stuff quickly
  As a user
  I want to access reports via the home page

  Scenario: Browse excludes unpublished reports
    Given a report named "Empty Report"
    And an unscored report named "Unscored Report"
    And a scored report named "Scored Report"
    And a published report named "Active Report"
    When I go to the home page
    Then I should see "Active Report"
    But I should not see "Empty Report"
    And I should not see "Unscored Report"
    And I should not see "Scored Report"

  Scenario: User sets their zip code from the instant grat section
    When I go to the home page
    And I fill in "Show Reps for Your Location" with "75028"
    And I press "Show Reps for Your Location"
    Then I should see "Zip: 75028"

    When I fill in "Show Reps for Your Location" with "90210"
    And I press "Show Reps for Your Location"
    Then I should see "Zip: 90210"
