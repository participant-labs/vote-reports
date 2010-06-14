Feature: Personalized report scoring
  In order to know who to vote for
  As a user
  I want to see aggregate scores for the reports I'm following

  Background:
    Given I am signed in as "Empact"
    And a published report named "Brady Campaign to Prevent Gun Violence"
    And a published report named "Aren't Circuses Great!?"
    And the following in-office politician records:
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

  @emulate_rails_javascript
  Scenario: User sees scores for followed reports
    And user "Empact" is following report "Brady Campaign to Prevent Gun Violence"
    And I wait for delayed job to finish
    When I go to my profile page
    And I follow "Personalized Report"
    Then I should see the following scores:
      | politician    | score |
      | Piyush Jindal | 97    |
      | Ron Wyden     | 33    |

    Given user "Empact" is following report "Aren't Circuses Great!?"
    And I wait for delayed job to finish
    When I go to my profile page
    And I follow "Personalized Report"
    Then I should see the following scores:
      | politician    | score |
      | Piyush Jindal | 54    |
      | Ron Wyden     | 31    |

    When I go to my profile page
    And I follow "Reports you Follow"
    And I follow "Unfollow Brady Campaign to Prevent Gun Violence"
    And I wait for delayed job to finish
    And I go to my profile page
    And I follow "Personalized Report"
    Then I should see the following scores:
      | politician    | score |
      | Piyush Jindal | 11    |
      | Ron Wyden     | 29    |
