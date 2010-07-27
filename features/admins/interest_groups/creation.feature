Feature: Creating Interest Groups
  In order to fill-in interest groups not available from PVS
  As an admin
  I want to create interest groups and record their policy preferences

  Background:
    Given an admin named "Admin"
    When I log in as "Admin/password"

  Scenario: Navigating to the new interest group page
    When I go to the interest groups page
    And I follow "Create a new Interest Group"
    Then I should be on the new interest group page

  Scenario: Interest Group Creation
    When I go to the new interest group page
    And I fill in the following:
     | Name         | My favorite interest group                     |
     | Description  | Why do I like it so much? It boggles the mind. |
     | Email        | tops@place.org                                 |
     | Url          | http://place.org                               |
     | Contact name | Mr. Tops                                       |
    And I press "Create Interest Group"
    Then I should see "Successfully created Interest Group"
    And I should be on the interest group page for "My favorite interest group"
    And I should see "Why do I like it so much? It boggles the mind."
