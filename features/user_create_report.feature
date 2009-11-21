Feature: User create report
  In order to add content to the site
  A user
  Should be able to create a report
  
    Scenario: User creates a report
      Given I am signed in
      When I go to my profile page
      And I follow "Create a report"