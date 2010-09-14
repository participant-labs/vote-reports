Feature: Browsing Interest Groups
  In order to find interest groups I agree with
  As a user
  I want to browse interest groups

  Background:
    Given an interest group named "Sierra Club"

  Scenario: Guest reads instructions on how to claim
    When I go to the interest group page for "Sierra Club"
    And I follow "Claim this Page"
    Then I should see "Claiming this Interest Group"
    And I should see "To claim this page, just send us an email send us an email at"
