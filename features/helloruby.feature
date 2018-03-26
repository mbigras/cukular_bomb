Feature: Ruby's command line interface
  Scenario: Using the -e flag
    When I run `ruby -e 'print "hello world!"'`
    Then the command should pass with:
      """
      hello world!
      """
