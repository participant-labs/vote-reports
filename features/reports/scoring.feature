Feature: Scoring Reports
  In order to leverage report data in an actionable form
  As a user
  I want to generate scores for each politician associated with this report's criteria

  Background:
    Given I have an unlisted report named "Active Report"
    And an un-voted, current-congress bill named "Bovine Security Act of 2009"
    And an un-voted, current-congress bill named "USA PATRIOT Reauthorization Act of 2009"
    And an un-voted, current-congress bill named "Honoring Miss America Act of 2009"
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

  Scenario: Without Criteria, I should see message noting why no scores exist
    When I go to my report page for "Active Report"
    And I follow "Scores"
    Then I should see "No scores yet, as this report has no criteria to judge representatives by."

  Scenario: With Criteria on unvoted bills, I should see message noting that as the bills are unvoted, no scores exist
    Given report "Active Report" has the following bill criteria:
      | bill                                    | support |
      | Bovine Security Act of 2009             | true    |
      | USA PATRIOT Reauthorization Act of 2009 | false   |
    And I wait for delayed job to finish
    When I go to my report page for "Active Report"
    And I follow "Scores"
    Then I should see "No scores yet, as the associated legislation has not been voted on."

  Scenario: With Criteria on bills without passage rolls, I should see message noting that as the bills are unvoted, no scores exist
    Given bill "Bovine Security Act of 2009" has the following rolls:
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
    And report "Active Report" has the following bill criteria:
      | bill                                    | support |
      | Bovine Security Act of 2009             | true    |
    And I wait for delayed job to finish
    When I go to my report page for "Active Report"
    And I follow "Scores"
    Then I should see "No scores yet, as the associated legislation has not been voted on."

  Scenario: Bill Criteria report generates scores
    Given bill "Bovine Security Act of 2009" has the following passage votes:
      | politician     | vote |
      | Piyush Jindal  | +    |
      | J. Kerrey      | P    |
      | Martin Sabo    | 0    |
      | Edward Kaufman | -    |
      | Connie Mack    |      |
    And report "Active Report" has the following bill criterion:
      | bill                        | support |
      | Bovine Security Act of 2009 | true    |
    When I wait for delayed job to finish
    And I go to my report page for "Active Report"
    And I follow "Scores"
    Then I should see the following scores:
      | politician           | score |
      | Piyush Jindal        | 100   |
      | J. Kerrey            | 50    |
      | Martin Sabo          | 50    |
      | Edward Kaufman       | 0    |
    And I should not see "Connie Mack"

    When I follow "Piyush Jindal"
    Then I should be on the politician page for "Piyush Jindal"

  Scenario: Bill Criteria report doesn't generates scores over 100
    Given bill "Bovine Security Act of 2009" has the following passage votes on "12/24/2009":
      | politician     | vote |
      | Piyush Jindal  | +    |
    And bill "Bovine Security Act of 2009" has the following passage votes on "12/23/2009":
      | politician     | vote |
      | Piyush Jindal  | +    |
    And bill "Bovine Security Act of 2009" has the following passage votes on "11/23/2009":
      | politician     | vote |
      | Piyush Jindal  | +    |
    And bill "USA PATRIOT Reauthorization Act of 2009" has the following passage votes on "3/25/2010":
      | politician     | vote |
      | Piyush Jindal  | +    |
    And report "Active Report" has the following bill criterion:
      | bill                        | support |
      | Bovine Security Act of 2009 | true    |
      | USA PATRIOT Reauthorization Act of 2009 | true    |
    When I wait for delayed job to finish
    And I go to my report page for "Active Report"
    And I follow "Scores"
    Then I should see the following scores:
      | politician           | score |
      | Piyush Jindal        | 100   |

  Scenario: Bill Criteria report scores combine
    Given the following bill passage votes:
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
    And report "Active Report" has the following bill criteria:
      | bill                                    | support |
      | Bovine Security Act of 2009             | true    |
      | USA PATRIOT Reauthorization Act of 2009 | false   |
      | Honoring Miss America Act of 2009       | true   |
    When I go to my report page for "Active Report"
    And I follow "Scores"
    Then I should see "Scores are being generated. Please try again in a moment."
    When I wait for delayed job to finish
    And I go to my report page for "Active Report"
    And I follow "Scores"
    Then I should see the following scores:
      | politician           | score |
      | Connie Mack          | 100   |
      | Roscoe Bartlett      | 100   |
      | Edward Kaufman       | 100   |
      | Frank Ballance       | 0     |
      | Tammy Baldwin        | 0     |
      | J. Kerrey            | 75    |
      | Martin Sabo          | 75    |
      | Neil Abercrombie     | 25    |
      | Brad Carson          | 75    |
      | Robert Aderholt      | 25    |
      | Thomas Allen         | 75    |
      | Brian Baird          | 25    |
      | Spencer Bachus       | 25    |
      | Joe Baca             | 0     |
    And I should see "Next"

  Scenario: Bill Criteria report generate scores from passing roles only
    Given bill "Bovine Security Act of 2009" has the following rolls:
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
    And report "Active Report" has the following bill criterion:
      | bill                        | support |
      | Bovine Security Act of 2009 | true    |
    When I go to my report page for "Active Report"
    And I follow "Scores"
    Then I should see "Scores are being generated. Please try again in a moment."
    When I wait for delayed job to finish
    And I go to my report page for "Active Report"
    And I follow "Scores"
    Then I should see the following scores:
      | politician           | score |
      | Piyush Jindal        | 100   |
      | J. Kerrey            | 25    |
      | Martin Sabo          | 75    |
      | Edward Kaufman       | 50    |
      | Connie Mack          | 50    |
      | Neil Abercrombie     | 0     |

  Scenario: Bill Criteria report doesn't dilute scores with rolls which don't apply to a given pol
    Given bill "Bovine Security Act of 2009" has the following rolls:
      | roll_type                                            |
      | On Passage                                           |
      | On the Cloture Motion                                |
      | Passage, Objections of the President Notwithstanding |
    And bill "Bovine Security Act of 2009" has the following roll votes:
      | politician       | On Passage | On the Cloture Motion | Passage, Objections of the President Notwithstanding |
      | Piyush Jindal    | + | + |   |
      | J. Kerrey        | P | - |   |
      | Martin Sabo      | 0 | + |   |
      | Edward Kaufman   | - |   | + |
      | Connie Mack      |   |   | P |
      | Neil Abercrombie | - |   | - |
    And report "Active Report" has the following bill criterion:
      | bill                        | support |
      | Bovine Security Act of 2009 | true    |
    When I go to my report page for "Active Report"
    And I follow "Scores"
    Then I should see "Scores are being generated. Please try again in a moment."
    When I wait for delayed job to finish
    And I go to my report page for "Active Report"
    And I follow "Scores"
    Then I should see the following scores:
      | politician           | score |
      | Piyush Jindal        | 100   |
      | J. Kerrey            | 25    |
      | Martin Sabo          | 75    |
      | Edward Kaufman       | 50    |
      | Connie Mack          | 50    |
      | Neil Abercrombie     | 0     |

  Scenario: Bill Criteria report discounts the impact of past votes within the same criterion
    Given bill "Bovine Security Act of 2009" has the following rolls:
      | roll_type                                            | voted_at     |
      | On Passage                                           | 2.years.ago  |
      | On the Cloture Motion                                | 1.year.ago   |
      | Passage, Objections of the President Notwithstanding | 6.months.ago |
    And bill "Bovine Security Act of 2009" has the following roll votes:
      | politician       | On Passage | On the Cloture Motion | Passage, Objections of the President Notwithstanding |
      | Piyush Jindal    | + | + |   |
      | J. Kerrey        | P | - |   |
      | Martin Sabo      | 0 | + |   |
      | Edward Kaufman   | - |   | + |
      | Connie Mack      |   |   | P |
      | Neil Abercrombie | - |   | - |
    And report "Active Report" has the following bill criterion:
      | bill                        | support |
      | Bovine Security Act of 2009 | true    |
    When I go to my report page for "Active Report"
    And I follow "Scores"
    Then I should see "Scores are being generated. Please try again in a moment."
    When I wait for delayed job to finish
    And I go to my report page for "Active Report"
    And I follow "Scores"
    Then I should see the following scores:
      | politician           | score |
      | Piyush Jindal        | 100   |
      | J. Kerrey            | 24    |
      | Martin Sabo          | 76    |
      | Edward Kaufman       | 53    |
      | Connie Mack          | 50    |
      | Neil Abercrombie     | 0     |

  Scenario: Bill Criteria report discounts the impact of past votes between criterions
    Given a 2005 bill named "Honoring Bo Jackson Act of 2005"
    And bill "Bovine Security Act of 2009" has the following rolls:
      | roll_type                                            | voted_at     |
      | On Passage                                           | 2.years.ago  |
      | On the Cloture Motion                                | 1.year.ago   |
      | Passage, Objections of the President Notwithstanding | 6.months.ago |
    # Base = (((1 - 0.07) ^ 2) + ((1 - 0.07) ^ 1)  + ((1 - 0.07) ^ .5)) / 3 = 91.9755025
    And bill "Honoring Bo Jackson Act of 2005" has the following rolls:
      | roll_type             | voted_at     |
      | On Passage            | 3.years.ago  |
      | On the Cloture Motion | (1.year + 6.months).ago |
    # Base = (((1 - 0.07) ^ 3) + ((1 - 0.07) ^ 1.5)) / 2 = 85.060826
    # Relative Base = 91.9755025 + 85.060826 / 2 = 88.5181643
    And bill "Bovine Security Act of 2009" has the following roll votes:
      | politician       | On Passage | On the Cloture Motion | Passage, Objections of the President Notwithstanding |
      | Piyush Jindal    | + | + |   |
      | J. Kerrey        | P | - |   |
      | Martin Sabo      | 0 | + |   |
      | Edward Kaufman   | - |   | + |
      | Connie Mack      |   |   | P |
      | Neil Abercrombie | - |   | - |
    And bill "Honoring Bo Jackson Act of 2005" has the following roll votes:
      | politician       | On Passage | On the Cloture Motion |
      | Piyush Jindal    | - | - |
      | J. Kerrey        | + | P |
      | Martin Sabo      | + | 0 |
      | Edward Kaufman   | - | 0 |
      | Connie Mack      | + | + |
      | Neil Abercrombie | + |   |
    And report "Active Report" has the following bill criterion:
      | bill                            | support |
      | Bovine Security Act of 2009     | true    |
      | Honoring Bo Jackson Act of 2005 | false   |
    When I go to my report page for "Active Report"
    And I follow "Scores"
    Then I should see "Scores are being generated. Please try again in a moment."
    When I wait for delayed job to finish
    And I go to my report page for "Active Report"
    And I follow "Scores"
    Then I should see the following scores:
      | politician           | score |
      | Piyush Jindal        | 100   |
      | J. Kerrey            | 25    |
      | Martin Sabo          | 52    |
      | Edward Kaufman       | 63    |
      | Connie Mack          | 27    |
      | Neil Abercrombie     | 0     |
