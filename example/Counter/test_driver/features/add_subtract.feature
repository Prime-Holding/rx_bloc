Feature: AddFeature
  Test add features

  Scenario: Test Increment feature of the app
    Given I test the initial state of the app with value as 0
    And I click the Increment button
    Then I see if the values is 1

  Scenario: Test Decrement feature of the app
    Given I test the initial state of the app with value as 0
    And I click the Increment button
    And I click the Increment button
    And I click the Decrement button
    Then I see if the values is 1