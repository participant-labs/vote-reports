Feature: Browsing Causes
  In order to discover causes of interest and their related reports
  As a user
  I want to browse causes

  Background:
    Given a cause named "Lollipops!"

  Scenario: Visiting the Cause Index from the home page
    When I go to the home page
    And I follow "Causes"
    Then I should see "Browse Causes"
    When I follow "Lollipops!"
    Then I should be on the cause page for "Lollipops!"

  @javascript
  Scenario: Viewing the reports associated with a cause
    Given a published report named "Brady Campaign to Prevent Gun Violence"
    And cause "Lollipops!" includes report "Brady Campaign to Prevent Gun Violence"
    When I go to the cause page for "Lollipops!"
    And I follow "Reports"
    Then I should see "Brady Campaign to Prevent Gun Violence"
