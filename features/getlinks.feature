Feature: Query
  In order to get links
  As a user
  I want to query a URL
  
  Scenario: Query URL
    Given I have run the program
    And I have defined the query
    When I inspect the query
    Then the object should be the result of the query
