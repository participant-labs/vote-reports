Feature: Scoring Reports
  In order to leverage report data in an actionable form
  As a user
  I want to generate scores for each politician associated with this report's criteria

  Background:
    Given I have a report named "Active Report"
    And an un-voted, current-congress bill named "Bovine Security Act of 2009"
    And an un-voted, current-congress bill named "USA PATRIOT Reauthorization Act of 2009"
    And the following politician records:
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

  Scenario: Without Criteria, I should see message noting why no scores exist
    When I go to my report page for "Active Report"
    Then I should see "No scores yet, as this report has no criteria to judge representatives by."

  Scenario: With Criteria on unvoted bills, I should see message noting the bills are unvoted, and so no scores exist
    Given report "Active Report" has the following bill criteria:
      | bill                                    | support |
      | Bovine Security Act of 2009             | true    |
      | USA PATRIOT Reauthorization Act of 2009 | false   |
    When I go to my report page for "Active Report"
    Then I should see "No scores yet, as the associated bills have not been voted on."
    And I should see "(unvoted)"

  Scenario: With Criteria on bills without passage rolls, I should see message noting the bills are unvoted, and so no scores exist
    Given report "Active Report" has the following bill criteria:
      | bill                                    | support |
      | Bovine Security Act of 2009             | true    |
    And bill "Bovine Security Act of 2009" has the following rolls:
      | roll_type                                          |
      | On Agreeing to the Amendments en bloc, as modified |
    And bill "Bovine Security Act of 2009" has the following roll votes:
      | politician       | On Agreeing to the Amendments en bloc, as modified |
      | Piyush Jindal    | + |
      | J. Kerrey        | P |
      | Martin Sabo      | 0 |
      | Edward Kaufman   | - |
      | Connie Mack      |   |
      | Neil Abercrombie | - |
    When I go to my report page for "Active Report"
    Then I should see "No scores yet, as the associated bills have not been voted on."
    And I should see "(unvoted)"

  Scenario: Bill Criteria report generates scores
    Given report "Active Report" has the following bill criterion:
      | bill                        | support |
      | Bovine Security Act of 2009 | true    |
    And bill "Bovine Security Act of 2009" has the following bill passage votes:
      | politician     | vote |
      | Piyush Jindal  | +    |
      | J. Kerrey      | P    |
      | Martin Sabo    | 0    |
      | Edward Kaufman | -    |
      | Connie Mack    |      |
    When I go to my report page for "Active Report"
    Then I should see the following scores:
      | politician           | score |
      | Piyush Jindal        | 100   |
      | J. Kerrey            | 50    |
      | Martin Sabo          | 50    |
      | Edward Kaufman       | 0    |
    And I should not see "Connie Mack"

    When I follow "Piyush Jindal"
    Then I should be on the politician page for "Piyush Jindal"

  Scenario: Bill Criteria report scores combine
    Given report "Active Report" has the following bill criteria:
      | bill                                    | support |
      | Bovine Security Act of 2009             | true    |
      | USA PATRIOT Reauthorization Act of 2009 | false   |
    And the following bill passage votes:
      | politician     | Bovine Security Act of 2009  | USA PATRIOT Reauthorization Act of 2009 |
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
    When I go to my report page for "Active Report"
    Then I should see the following scores:
      | politician           | score |
      | Piyush Jindal        | 50    |
      | J. Kerrey            | 75    |
      | Martin Sabo          | 75    |
      | Edward Kaufman       | 100   |
      | Connie Mack          | 75    |
      | Neil Abercrombie     | 25    |
      | Aníbal Acevedo-Vilá  | 50    |
      | Julia Carson         | 50    |
      | Brad Carson          | 75    |
      | Gary Ackerman        | 50    |
      | Robert Aderholt      | 25    |
      | W. Akin              | 50    |
      | Rodney Alexander     | 50    |
      | Thomas Allen         | 75    |
      | Robert Andrews       | 50    |
      | Joe Baca             | 0     |
      | Spencer Bachus       | 25    |
      | Brian Baird          | 25    |
      | Richard Baker        | 50    |
      | Tammy Baldwin        | 25    |
      | Frank Ballance       | 25    |
      | Cass Ballenger       | 50    |
      | James Barrett        | 50    |
      | Roscoe Bartlett      | 75    |
    And I should not see "Joe Barton"

  Scenario: Bill Criteria report generate scores from passing roles only
    Given report "Active Report" has the following bill criterion:
      | bill                        | support |
      | Bovine Security Act of 2009 | true    |
    And bill "Bovine Security Act of 2009" has the following rolls:
      | roll_type                                          |
      | On Passage                                         |
      | On the Cloture Motion                              |
      | On Agreeing to the Amendments en bloc, as modified |
    And bill "Bovine Security Act of 2009" has the following roll votes:
      | politician       | On Passage | On the Cloture Motion | On Agreeing to the Amendments en bloc, as modified |
      | Piyush Jindal    | + | + | + |
      | J. Kerrey        | P | - | + |
      | Martin Sabo      | 0 | + | - |
      | Edward Kaufman   | - | + | + |
      | Connie Mack      |   | P | - |
      | Neil Abercrombie | - | - | 0 |
    When I go to my report page for "Active Report"
    Then I should see the following scores:
      | politician           | score |
      | Piyush Jindal        | 100   |
      | J. Kerrey            | 25    |
      | Martin Sabo          | 75    |
      | Edward Kaufman       | 50    |
      | Connie Mack          | 50    |
      | Neil Abercrombie     | 0     |
