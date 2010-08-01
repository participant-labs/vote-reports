@homepagey
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
    Then I should not see "Empty Report"
    And I should not see "Unscored Report"
    And I should not see "Scored Report"
    But I should see "Active Report"

  Scenario: User sets their zip code from the instant grat section
    Given my location is assured
    When I go to the home page
    And I follow "set location"
    And I fill in "Your Location" with "75028"
    And I press "Set"
    Then I should see "Flower Mound, TX 75028"

    When I follow "set location"
    And I fill in "Your Location" with "90210"
    And I press "Set"
    Then I should see "Beverly Hills, CA 90210"
