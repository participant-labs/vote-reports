Feature: Scoring Reports
  In order to leverage report data in an actionable form
  As a user
  I want to generate scores for each politician associated with this report's criteria

  Background:
    Given an interest group named "AARP"
    And an un-voted, current-congress bill named "Bovine Security Act of 2003"
    And an un-voted, current-congress bill named "USA PATRIOT Reauthorization Act of 2003"
    And an un-voted, current-congress bill named "Honoring Miss America Act of 2003"
    And the following in-office politician records:
      | name                  |
      | Piyush Jindal         |
      | J. Kerrey             |
      | Martin Sabo           |
      | Edward Kaufman        |
      | Connie Mack           |
      | Neil Abercrombie      |
      | Aníbal Acevedo-Vilá   |
      | Julia Carson          |
      | Brad Carson           |
      | Gary Ackerman         |
      | Robert Aderholt       |
      | W. Akin               |
      | Rodney Alexander      |
      | Thomas Allen          |
      | Robert Andrews        |
      | Joe Baca              |
      | Spencer Bachus        |
      | Brian Baird           |
      | Richard Baker         |
      | Tammy Baldwin         |
      | Frank Ballance        |
      | Cass Ballenger        |
      | James Barrett         |
      | Roscoe Bartlett       |
      | Joe Barton            |

  Scenario: Bill Criteria report scores combine
    Given the following bill passage votes:
      | politician     | Bovine Security Act of 2003  | USA PATRIOT Reauthorization Act of 2003 |
      | Piyush Jindal         | + | + |
      | J. Kerrey             | + | P |
      | Martin Sabo           | + | 0 |
      | Edward Kaufman        | + | - |
      | Connie Mack           | + |   |
      | Neil Abercrombie      | P | + |
      | Aníbal Acevedo-Vilá   | P | P |
      | Julia Carson          | P | 0 |
      | Brad Carson           | P | - |
      | Gary Ackerman         | P |   |
      | Robert Aderholt       | 0 | + |
      | W. Akin               | 0 | P |
      | Rodney Alexander      | 0 | 0 |
      | Thomas Allen          | 0 | - |
      | Robert Andrews        | 0 |   |
      | Joe Baca              | - | + |
      | Spencer Bachus        | - | P |
      | Brian Baird           | - | 0 |
      | Richard Baker         | - | - |
      | Tammy Baldwin         | - |   |
      | Frank Ballance        |   | + |
      | Cass Ballenger        |   | P |
      | James Barrett         |   | 0 |
      | Roscoe Bartlett       |   | - |
      | Joe Barton            |   |   |
    And interest group "AARP" has the following bill criteria:
      | bill                                    | support |
      | Bovine Security Act of 2003             | true    |
      | USA PATRIOT Reauthorization Act of 2003 | false   |
      | Honoring Miss America Act of 2003       | true   |
    And interest group "AARP" has the following ratings:
      | report   | politician            | rating |
      | 2004     | Connie Mack           | 0      |
      | 2004     | Roscoe Bartlett       | 30     |
      | 2004     | Edward Kaufman        | 20     |
      | 2004     | Frank Ballance        | 25     |
      | 2004     | Tammy Baldwin         | 80     |
      | 2004     | J. Kerrey             | 100    |
      | 2004     | Martin Sabo           | 0      |
      | 2004     | Neil Abercrombie      | 30     |
      | 2004     | Brad Carson           | 20     |
      | 2004     | Robert Aderholt       | 25     |
      | 2004     | Thomas Allen          | 80     |
      | 2004     | Brian Baird           | 100    |
      | 2004     | Spencer Bachus        | 80     |
      | 2004     | Joe Baca              | 100    |
    When I wait for delayed job to finish
    And I go to the interest group scores page for "AARP"
    Then I should see the following scores:
      | politician           | score |
      | Roscoe Bartlett      | 65    |
      | Edward Kaufman       | 73    |
      | J. Kerrey            | 83    |
      | Brad Carson          | 56    |
      | Thomas Allen         | 77    |
      | Brian Baird          | 50    |
    When I follow "Next"
    Then I should see the following scores:
      | politician           | score |
      | Martin Sabo          | 50    |
      | Robert Aderholt      | 25    |
      | Neil Abercrombie     | 27    |
      | Frank Ballance       | 13    |
      | Tammy Baldwin        | 40    |
      | Connie Mack          | 50    |
      | Spencer Bachus       | 44    |
      | Joe Baca             | 34    |

  Scenario: Bill Criteria report discounts the impact of past votes within the same criterion
    Given bill "Bovine Security Act of 2003" has the following rolls:
      | roll_type                                            | voted_at     |
      | On Passage                                           | 2.years.ago  |
      | On the Cloture Motion                                | 1.year.ago   |
      | Passage, Objections of the President Notwithstanding | 6.months.ago |
    And bill "Bovine Security Act of 2003" has the following roll votes:
      | politician       | On Passage | On the Cloture Motion | Passage, Objections of the President Notwithstanding |
      | Piyush Jindal    | + | + |   |
      | J. Kerrey        | P | - |   |
      | Martin Sabo      | 0 | + |   |
      | Edward Kaufman   | - |   | + |
      | Connie Mack      |   |   | P |
      | Neil Abercrombie | - |   | - |
    And interest group "AARP" has the following bill criterion:
      | bill                        | support |
      | Bovine Security Act of 2003 | true    |
    And interest group "AARP" has the following ratings:
      | report    | politician            | rating |
      | 2008      | Piyush Jindal         | 0      |
      | 2008      | J. Kerrey             | 30     |
      | 2008      | Martin Sabo           | 20     |
      | 2008      | Edward Kaufman        | 25     |
      | 2008      | Connie Mack           | 80     |
      | 2008      | Neil Abercrombie      | 100    |
      | Fall 2003 | Piyush Jindal         | 100    |
      | Fall 2003 | J. Kerrey             | 30     |
      | Fall 2003 | Martin Sabo           | 0      |
      | Fall 2003 | Edward Kaufman        | 70     |
      | Fall 2003 | Connie Mack           | 12     |
      | Fall 2003 | Neil Abercrombie      | 100    |
    When I wait for delayed job to finish
    And I go to the interest group scores page for "AARP"
    Then I should see the following scores:
      | politician           | score |
      | Piyush Jindal        | 64    |
      | J. Kerrey            | 28    |
      | Martin Sabo          | 36    |
      | Edward Kaufman       | 47    |
      | Connie Mack          | 51    |
      | Neil Abercrombie     | 61    |
