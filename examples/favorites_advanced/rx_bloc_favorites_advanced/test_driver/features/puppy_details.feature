Feature: Puppy details
  Test Puppy details page

  Scenario: Successfully open puppy details page
    Given I expect the widget 'PuppySearchPage' to be present within 10 seconds
    When I press the puppy card with id '0-0'
    And I expect the widget 'PuppyDetailsPage' to be present within 10 seconds
    Then I expect the text 'Charlie 0' to be present