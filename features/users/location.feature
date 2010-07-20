@homepagey @locationy
Feature: User Location
  In order to offer scores relevant to the user
  A user
  Should have their location stored, and modifiable

  Scenario Outline: User with no location stored can follow a link to set it
    When I go to <page>
    And I follow "set location"
    And I fill in "Your Location" with "75028"
    And I press "Set"
    Then I should be on <page>
    And I should see "Successfully set location"
    And I should see "Zip: 75028"

  Examples:
    | page             |
    | the home page    |
    | the reports page |

  @emulate_rails_javascript
  Scenario: User should be able to clear existing location
    Given my location is set to "75028"
    When I go to the home page
    And I follow "clear"
    Then I should see "Successfully cleared location"
    And I should not see "75028"
    And I should be on the home page
