Feature: Editing Interest Group Images
  In order to add images to interest groups
  As an admin
  I want to edit the interest group image

  Background:
    Given an interest group named "AARP"
    And I am signed in as an Admin

  Scenario: Navigating to the image edit page on an interest group
    When I go to the interest group page for "AARP"
    And I follow "Edit Interest Group"
    And I follow "Edit Thumbnail"
    Then I should see "Replace Thumbnail"
    And I should be on the edit interest group image page for "AARP"

  Scenario: Updating the image on an interest group with an invalid image
    When I go to the edit interest group image page for "AARP"
    And I attach the file "public/images/gov_track_logo.png" to "image_thumbnail"
    And I press "Replace!"
    Then I should be on the interest group page for "AARP"
    And I should see "Unable to update thumbnail."
    And I should not see the image "gov_track_logo.png"

  Scenario: Updating the image on an interest group
    Given this is pending
    When I go to the edit interest group image page for "AARP"
    And I attach the file "public/images/mobile_commons_logo.png" to "image_thumbnail"
    And I press "Replace!"
    Then I should be on the interest group page for "AARP"
    And I should see "Successfully updated thumbnail."
    And I should see the image "mobile_commons_logo.png"
