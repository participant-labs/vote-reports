Feature: Browsing Interest Groups
  In order to find interest groups I agree with
  As a user
  I want to browse interest groups

  Background:
    Given an interest group named "Sierra Club"

  Scenario: Navigating to the interest group list
    Given I am on the home page
    When I follow "Interest Groups"
    Then I should see "Interest Groups"
    And I should see "Sierra Club"
