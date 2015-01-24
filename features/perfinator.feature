Feature: Perfinator has working help
  In order to get going on coding my awesome app
  I want to have aruba and cucumber setup
  So I don't have to do it myself

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
