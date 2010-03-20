Feature: Personal Report
  In order to stay know who to vote for
  As a user
  I want to create a personal report based on those reports I agree with

  Scenario: User follows one report, whose scores are displayed on the personal report
    Given the following politician records:
      | name                  |
      | Piyush Jindal         |
      | J. Kerrey             |
      | Martin Sabo           |
    And a published report named "A Certain Published Report"
    And report "A Certain Published Report" has the following scores:
      | politician           | score |
      | Piyush Jindal        | 100   |
      | J. Kerrey            | 25    |
      | Martin Sabo          | 75    |
    And I am signed in
    And I am following report "A Certain Published Report"
    When I wait for delayed job to finish
    And I go to my profile page
    And I follow "Your Personalized Report"
    Then I should be on my personalized report page
    And I should see "Your Personalized Report"
    And I should see the following scores:
      | politician           | score |
      | Piyush Jindal        | 100   |
      | J. Kerrey            | 25    |
      | Martin Sabo          | 75    |

  Scenario: User follows multiple reports, whose scores are displayed on the personal report
    Given the following politician records:
      | name                  |
      | Piyush Jindal         |
      | J. Kerrey             |
      | Martin Sabo           |
    Given I am signed in
    And a published report named "A Certain Published Report"
    And report "A Certain Published Report" has the following scores:
      | politician           | score |
      | Piyush Jindal        | 100   |
      | J. Kerrey            | 25    |
      | Martin Sabo          | 75    |
    And a published report named "Another Published Report"
    And report "Another Published Report" has the following scores:
      | politician           | score |
      | Piyush Jindal        | 12    |
      | J. Kerrey            | 37    |
      | Martin Sabo          | 99    |
    And I am following report "A Certain Published Report"
    And I am following report "Another Published Report"

    When I wait for delayed job to finish
    And I go to my profile page
    And I follow "Your Personalized Report"
    Then I should be on my personalized report page
    And I should see "Your Personalized Report"
    And I should see the following scores:
      | politician           | score |
      | Piyush Jindal        | 100   |
      | J. Kerrey            | 25    |
      | Martin Sabo          | 75    |
