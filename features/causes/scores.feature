Feature: Cause Scores
  In order to discover high-level scores for my politicians
  As a user
  I want to browse cause scores

  Background:
    Given a cause named "Lollipops!"
    And a published report named "Brady Campaign to Prevent Gun Violence"
    And a published report named "Aren't Circuses Great!?"

  Scenario: Viewing cause scores derived from associated reports
    Given the following in-office politician records:
      | name                  |
      | Piyush Jindal         |
      | Ron Wyden             |
    And report "Brady Campaign to Prevent Gun Violence" has the following scores:
      | politician    | score |
      | Piyush Jindal | 97    |
      | Ron Wyden     | 33    |
    And report "Aren't Circuses Great!?" has the following scores:
      | politician    | score |
      | Piyush Jindal | 11.3  |
      | Ron Wyden     | 28.6  |
    And cause "Lollipops!" includes report "Brady Campaign to Prevent Gun Violence"
    And cause "Lollipops!" includes report "Aren't Circuses Great!?"
    When I wait for delayed job to finish
    And I go to the cause scores page for "Lollipops!"
    Then I should see the following scores:
      | politician    | score |
      | Piyush Jindal | 54    |
      | Ron Wyden     | 31    |
