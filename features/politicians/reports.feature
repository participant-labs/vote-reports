Feature: Browsing Politician Reports
  In order to find politician leanings from specific groups and topics
  As a user
  I want to browse politician scores

  Background:
    Given I have a published report named "Active Report"
    And I have a published report named "Other Report"
    And the following politician records:
      | name                  |
      | Piyush Jindal         |
      | Ron Wyden             |

  @javascript
  Scenario: Searching related reports for specific topics
    Given report "Active Report" has the following scores:
      | politician    | score |
      | Piyush Jindal | 11.3  |
      | Ron Wyden     | 28.6  |
    Given report "Other Report" has the following scores:
      | politician    | score |
      | Piyush Jindal | 97    |
      | Ron Wyden     | 33    |
    When I go to the politician page for "Piyush Jindal"
    And I follow "Reports" within "#content"
    Then I should see the following report scores:
      | name          | score |
      | Other Report  | 97    |
      | Active Report | 11    |
    But I should not see the following report scores:
      | score |
      | 29    |
      | 33    |

    When I fill in "Search Reports" with "active" within "#content"
    And I press "Search"
    Then I should see the following report scores:
      | name          | score |
      | Active Report | 11    |
    But I should not see the following report scores:
      | score |
      | 29    |
      | 33    |
      | 97    |
    And I should not see "Other Report"

    When I fill in "Search Reports" with "other" within "#content"
    And I press "Search"
    Then I should see the following report scores:
      | name         | score |
      | Other Report | 97    |
    But I should not see the following report scores:
      | score |
      | 29    |
      | 33    |
      | 11    |
    And I should not see "Active Report"

    When I fill in "Search Reports" with "" within "#content"
    And I press "Search"
    Then I should see the following report scores:
      | name          | score |
      | Other Report  | 97    |
      | Active Report | 11    |
    But I should not see the following report scores:
      | score |
      | 29    |
      | 33    |

  Scenario: Viewing related reports from the Politicians Page
    Given I have a published report named "Active Report"
    And an un-voted, current-congress bill named "Bovine Security Act of 2009"
    And an un-voted, current-congress bill named "USA PATRIOT Reauthorization Act of 2009"
    And bill "Bovine Security Act of 2009" has the following rolls:
      | roll_type                                          |
      | On Passage                                         |
      | On the Cloture Motion                              |
      | On Agreeing to the Amendments en bloc, as modified |
    And bill "Bovine Security Act of 2009" has the following roll votes:
      | politician       | On Passage | On the Cloture Motion | On Agreeing to the Amendments en bloc, as modified |
      | Piyush Jindal    | + | + | - |
      | Ron Wyden        | - | + | - |
    And report "Active Report" has the following bill criterion:
      | bill                        | support |
      | Bovine Security Act of 2009 | true    |
    When I wait for delayed job to finish
    When I go to the politician page for "Piyush Jindal"
    And I follow "Reports" within "#content"
    Then I should see the following report scores:
      | name          | score |
      | Active Report | 100   |

    Given bill "USA PATRIOT Reauthorization Act of 2009" has the following rolls:
      | roll_type                                          |
      | On Passage                                         |
      | On the Cloture Motion                              |
      | On Agreeing to the Amendments en bloc, as modified |
    Given bill "USA PATRIOT Reauthorization Act of 2009" has the following passage votes:
      | politician | vote |
      | Ron Wyden  | -    |
    When I go to the politician page for "Ron Wyden"
    And I follow "Reports" within "#content"
    Then I should see the following report scores:
      | name          | score |
      | Active Report | 50    |
    But I should not see "Piyush Jindal"
