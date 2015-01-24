Feature: Perfinator has working help
  In order to help users pick up perfinator quickly
  I want the app to explain itself
  So I don't have to tell people what to do

  Scenario: App runs
    When I get help for "perfinator"
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app takes options
    And the following options should be documented:
      |--server|
      |--port|
      |--concurrent|
      |--requests|
      |--delay|
      |--file|
      |--[no-]random|
      |--version|
    And the banner should document that this app takes no arguments
