Feature: Creating Causes
  In order to provide a higher-level understanding of report scores
  As an admin
  I want to create causes and curate their report contents

  Scenario: Empty Cause Creation
    Given an admin named "Admin"
    When I log in as "Admin/password"
    And I go to the causes page
    And I follow "Create a new Cause"
    And I fill in the following:
     | Name        | My favorite cause                             |
     | Description | Why do I like it so much? It boggles the mind. |
    And I press "Create Cause"
    Then I should see "Successfully created Cause"
    And I should be on the cause page for "My favorite cause"
    And I should see "Why do I like it so much? It boggles the mind."
