Feature: Bill viewing
  In order to view specific bills and related content
  As a user
  I want to browse bills

  Scenario: User browses from a current congress bill to OpenCongress
    Given a current-congress bill named "USA PATRIOT Reauthorization Act of 2009"
    When I go to the bill page for "USA PATRIOT Reauthorization Act of 2009"
    Then I should see "View on OpenCongress"

  Scenario: User views all bill titles
    Given a bill named "USA PATRIOT Reauthorization Act of 2009"
    When I go to the bill page for "USA PATRIOT Reauthorization Act of 2009"
    Then I should see "All Titles"

    Given bill "USA PATRIOT Reauthorization Act of 2009" has a title "Cheney Fuck Yeah"
    When I go to the bill page for "USA PATRIOT Reauthorization Act of 2009"
    Then I should see "All Titles"
    And I should see "Cheney Fuck Yeah"

  Scenario: Follow an existing roll to its page
    Given a bill named "Bovine Security Act of 2009"
    And bill "Bovine Security Act of 2009" has a roll on the question "On Passage"
    When I go to the bill page for "Bovine Security Act of 2009"
    And I follow "On Passage"
    Then I should be on the roll page for "On Passage"
