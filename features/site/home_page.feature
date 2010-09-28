@homepagey
Feature: Browsing the Home Page
  In order to find the most important stuff quickly
  As a user
  I want to access reports via the home page

  Scenario: User sets their zip code from the instant grat section
    Given my location is assured
    When I go to the home page
    And I follow "set location"
    And I fill in "Your Location" with "75028"
    And I press "Set"
    Then I should see "Flower Mound, TX 75028"

    When I follow "Flower Mound, TX 7502"
    And I fill in "Your Location" with "90210"
    And I press "Set"
    Then I should see "Beverly Hills, CA 90210"
