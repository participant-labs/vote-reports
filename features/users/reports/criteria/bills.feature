Feature: Adding Bill Criteria to Reports
  In order to inject direct legislative meaning into my report
  As a user
  I want to add bills to my report

  Background:
    Given I am signed in as "Empact"
    And I have a report named "My report"
    When I go to the new bills page for my report "My report"

  Scenario Outline: User adds a bill to a report
    Given I have a personal report named "Target Report"
    And <bill type> named "USA PATRIOT Reauthorization Act of 2009"
    When I fill in "Search" with "patriot"
    And I press "Search"
    Then the "Search" field should contain "patriot"
    When I choose "Support"
    And I fill in "Explanatory Link" with "http://example.com/reports/empact/target-report"
    And I press "Save Bills"
    Then I should see "Successfully updated report."
    And I should be on my report page for "My report"
    And I should see "USA PATRIOT Reauthorization Act of 2009"
    And I should not see "no votes yet"
    When I follow "Support"
    Then I should be on my report page for "Target Report"

  Examples:
    | bill type                            |
    | a pass-voted, current-congress bill  |
    | a pass-voted, previous-congress bill |

  Scenario Outline: User can't add an unvoted bill to a report
    Given <bill type> named "USA PATRIOT Reauthorization Act of 2009"
    When I fill in "Search" with "patriot"
    And I press "Search"
    Then the "Search" field should contain "patriot"
    When I choose "Support"
    And I press "Save Bills"
    Then I should see "Successfully updated report."
    And I should be on my report page for "My report"
    And I should see "Support"
    And I should see "USA PATRIOT Reauthorization Act of 2009"
    And I should see "no votes yet"

  Examples:
    | bill type                            |
    | a voted, current-congress bill       |
    | an un-voted, current-congress bill   |

  Scenario Outline: User is unable to select an invalid bill for report
    Given an <bill type> bill named "USA PATRIOT Reauthorization Act of 2009"
    When I fill in "Search" with "patriot"
    And I press "Search"
    Then the "Search" field should contain "patriot"
    And I should see "USA PATRIOT Reauthorization Act of 2009"
    And I should see "unvoted"
    And I should not see "No bills found"
    When I follow "Back to Report"
    Then I should be on my report page for "My report"

  Examples:
    | bill type                   |
    | voted, previous-congress    |
    | un-voted, previous-congress |

  Scenario Outline: User can search voted bills only
    Given a <bill type> bill named "USA PATRIOT Reauthorization Act of 2009"
    When I fill in "Search" with "patriot"
    And I check "Voted Bills Only"
    And I press "Search"
    Then I should see "USA PATRIOT Reauthorization Act of 2009"
    And I should not see "unvoted"
    And I should not see "No bills found"

  Examples:
    | bill type                          |
    | pass-voted, current-congress       |
    | pass-voted, previous-congress      |

  Scenario Outline: User will not see unvoted bills when searching voted bills only
    Given a <bill type> bill named "USA PATRIOT Reauthorization Act of 2009"
    When I fill in "Search" with "patriot"
    And I check "Voted Bills Only"
    And I press "Search"
    Then I should not see "USA PATRIOT Reauthorization Act of 2009"
    And I should not see "unvoted"
    But I should see "No bills found"

  Examples:
    | bill type                   |
    | voted, previous-congress    |
    | un-voted, previous-congress |
    | voted, current-congress     |
    | un-voted, current-congress  |

  Scenario Outline: User can search current bills only
    Given a <bill type> bill named "USA PATRIOT Reauthorization Act of 2009"
    When I fill in "Search" with "patriot"
    And I check "Current Bills Only"
    And I press "Search"
    Then I should see "USA PATRIOT Reauthorization Act of 2009"
    And I should not see "No bills found"

  Examples:
    | bill type                    |
    | pass-voted, current-congress |
    | voted, current-congress      |
    | un-voted, current-congress   |

  Scenario Outline: User will not see old bills when searching current bills only
    Given a <bill type> bill named "USA PATRIOT Reauthorization Act of 2009"
    When I fill in "Search" with "patriot"
    And I check "Current Bills Only"
    And I press "Search"
    Then I should not see "USA PATRIOT Reauthorization Act of 2009"
    But I should see "No bills found"

  Examples:
    | bill type                     |
    | voted, previous-congress      |
    | un-voted, previous-congress   |
    | pass-voted, previous-congress |

  Scenario: User views bill year on search
    Given a 1997 bill named "USA PATRIOT Reauthorization Act of 2009"
    When I fill in "Search" with "patriot"
    And I press "Search"
    Then I should see "(1997)"

  Scenario: User cancels a bill search
    Given a voted, current-congress bill named "USA PATRIOT Reauthorization Act of 2009"
    When I fill in "Search" with "patriot"
    And I press "Search"
    And I follow "Back to Report"
    Then I should be on my report page for "My report"

  Scenario: User saves an empty bill search
    Given a voted, current-congress bill named "USA PATRIOT Reauthorization Act of 2009"
    When I fill in "Search" with "patriot"
    And I press "Search"
    And I press "Save"
    Then I should be on my report page for "My report"

  Scenario: User tries a new bill search from the results page
    Given a voted, current-congress bill named "USA PATRIOT Reauthorization Act of 2009"
    Given a voted, current-congress bill named "Bovine Security Act of 2009"
    When I fill in "Search" with "patriot"
    And I press "Search"
    Then I should see "USA PATRIOT Reauthorization Act of 2009"
    When I fill in "Search" with "bovine"
    And I press "Search"
    Then I should see "Bovine Security Act of 2009"
    When I choose "Support"
    And I press "Save Bills"
    Then I should see "Successfully updated report."
    And I should be on my report page for "My report"
    And I should see "Support"
    And I should see "Bovine Security Act of 2009"
