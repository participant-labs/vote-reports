Feature: Adding Amendment Criteria to user reports
  In order to inject direct legislative meaning into my interest group (and keep me up to date)
  As a user
  I want to add amendments to my reports

  Background:
    Given I am signed in as "Empact"
    And I have a report named "My report"
    When I go to the new bills page for my report "My report"

  Scenario: Admin adds an amendment to an interest group
    Given an interest group named "Target Interest Group"
    And a pass-voted, current-congress bill named "USA PATRIOT Reauthorization Act of 2009"
    And an amendment named "Fix this thing" on bill "USA PATRIOT Reauthorization Act of 2009"
    When I fill in "Search" with "patriot"
    And I press "Search"
    Then I should see "USA PATRIOT Reauthorization Act of 2009"
    But I should not see "Fix this thing"
    When I follow "amendments"
    Then I should see "Fix this thing" within "#report_amendments_results_table"
    When I choose "Support" within "#report_amendments_results_table"
    And I fill in "Explanatory Link" with "http://example.com/interest_groups/target-interest-group"
    And I press "Save Amendments"
    Then I should be on the edit page for my report "My report"
    And I should see "Successfully updated report amendments"
    When I follow "View this Report"
    Then I should be on my report page for "My report"
    When I go to my report page for "My report"
    And I follow "Scores"
    Then I should not see "no votes yet"
    When I go to my report page for "My report"
    And I follow "Agenda"
    Then I should not see "USA PATRIOT Reauthorization Act of 2009"
    But I should see "Fix this thing"
    When I follow "Support"
    Then I should be on the interest group page for "Target Interest Group"

    When I go to my report page for "My report"
    And I follow "Agenda"
    And I follow "Fix this thing"
    Then I should see "USA PATRIOT Reauthorization Act of 2009"
