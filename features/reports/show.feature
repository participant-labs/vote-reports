Feature: Browsing Reports
  In order to find interesting reports
  As a user
  I want to browse reports

  Scenario Outline: Owner can visit their own reports
    Given I am signed in
    And I have the following <type> report:
      | name      | description                |
      | My Report | I made this because I care |
    When I go to my report page for "My Report"
    Then I should see "I made this because I care"
    And I should not see "You may not access this page"
    And I should be on my report page for "My Report"

  Examples:
    | type      |
    | published |
    | unlisted  |
    | scored    |
    | unscored  |
    | private   |

  Scenario Outline: Non-owner can visit unlisted and published reports of others
    Given I am signed in as "Owner"
    And I have the following <type> report:
      | name      | description                |
      | My Report | I made this because I care |
    And I am signed in as "NonOwner"
    When I go to user "Owner"'s page for report "My Report"
    Then I should <see> "I made this because I care"
    And I should be on <destination>

  Examples:
    | type      | see     | destination                                |
    | published |     see | user "Owner"'s page for report "My Report" |
    | unlisted  |     see | user "Owner"'s page for report "My Report" |
    | scored    | not see | the reports page for "Owner"               |
    | unscored  | not see | the reports page for "Owner"               |
    | private   | not see | the reports page for "Owner"               |
