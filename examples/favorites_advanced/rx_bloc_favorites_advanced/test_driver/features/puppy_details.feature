Feature: Puppy details
  Test Puppy details

  Scenario: Successfully open puppy details page
    Given I expect the widget 'PuppySearchPage' to be present within 10 seconds
    And I expect the widget 'PuppyCardItem0-0' to be present within 10 seconds
    And I tap the 'PuppyCardItem0-0' widget
    And I expect the widget 'PuppyDetailsPage' to be present within 10 seconds
    Then I expect the text 'Charlie 0' to be present