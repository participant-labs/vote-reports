Feature: Editing Report Images
  In order to add images to report
  As a report owner
  I want to edit the report image

  Background:
    Given I am signed in
    And I have the following published report:
      | name      | description                |
      | My Report | I made this because I care |

  Scenario: Navigating to the image edit page on an interest group
    When I go to my report page for "My Report"
    And I follow "Edit Report"
    And I follow "Edit Thumbnail"
    Then I should see "Replace Thumbnail"
    And I should be on the edit image page for the report "My Report"

  Scenario: Updating the image on my report
    When I go to the edit image page for the report "My Report"
    And I attach the file "app/assets/images/homepage/circle_1.png" to "image_thumbnail"
    And I press "Replace!"
    Then I should be on my report page for "My Report"
    And I should see "Successfully updated thumbnail."
    And I should see the image "circle_1.png"
    # Updating
    When I go to the edit image page for the report "My Report"
    And I attach the file "app/assets/images/homepage/circle_2.png" to "image_thumbnail"
    And I press "Replace!"
    Then I should be on my report page for "My Report"
    And I should see "Successfully updated thumbnail."
    And I should see the image "circle_2.png"
