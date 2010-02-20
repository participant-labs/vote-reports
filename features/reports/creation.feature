Feature: User create report
  In order to add content to the site
  A user
  Should be able to create a report

    Scenario: User creates an empty report
      Given I am signed in
      When I go to my profile page
      And I follow "Create a report"
      And I fill in "Name" with "My report"
      And I fill in "Description" with "I made this because I care"
      And I press "Create Report"
      Then I should see "Successfully created report."
      When I follow "Done"
      Then I should be on the report page for "My report"

    Scenario: User signs in to create a report
      Given I signed up as:
        | email            | password |
        | email@person.com | password |
      When I go to the home page
      And I follow "Create a report"
      And I log in as "email@person.com/password"

    Scenario: User tries to create a report without a name
      Given I am signed in
      When I go to my profile page
      And I follow "Create a report"
      And I press "Create Report"
      Then I should see "Name can't be blank"

    Scenario: User tries to create a report with a reserved name
      Given I am signed in
      When I go to my profile page
      And I follow "Create a report"
      And I fill in "Name" with "New"
      And I press "Create Report"
      Then I should see "Name can not be "
      And I should not see "Slugs is invalid"
