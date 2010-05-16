Feature: Browsing Interest Groups
  In order to find interest groups I agree with
  As a user
  I want to browse interest groups

  Background:
    Given an interest group named "Sierra Club"

  Scenario: Navigating to the interest group list
    Given I go to the interest groups page
    Then I should see "Interest Groups"
    And I should see "Sierra Club"
