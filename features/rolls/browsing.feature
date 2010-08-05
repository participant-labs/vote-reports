Feature: Browsing Rolls
  In order to view specific roll details including how a politician voted on it
  As a user
  I want to browse rolls

  Scenario: Browsing Rolls
    Given a bill named "Bovine Security Act of 2009"
    And bill "Bovine Security Act of 2009" has the following rolls:
      | question   | voted_at   |
      | On Passage | 12/24/2009 |
    And I go to the roll page for "On Passage"
    Then I should see "On Passage"
    And I should see "24 Dec 2009"
    And I should see "Subject"
    And I should see "Bovine Security Act of 2009"
  
    When I follow "Bovine Security Act of 2009"
    Then I should be on the bill page for "Bovine Security Act of 2009"
