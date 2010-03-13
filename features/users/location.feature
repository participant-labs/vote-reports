Feature: User Location
  In order to offer scores relevant to the user
  A user
  Should have their location stored, and modifiable

  Scenario: User with no location stored can follow a link to set it
    When I go to the home page
    And I follow "Set your location!"
    And I fill in "Zip Code" with "75028"
    And I press "Save"
    Then I should be on the home page
    And I should see "Zip: 75028"
