Feature: Bill viewing
  In order to view specific bills and related content
  As a user
  I want to be able to sign up
  
    Scenario: User views a specific bill
      When I go to the bills page
      And I fill in "Search" with "Patriot Act"
      And I press "Search"
      Then I should see "USA PATRIOT Reauthorization Act of 2009"
