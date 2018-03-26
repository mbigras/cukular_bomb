# Cukular Bomb

> Example repo to illustrate how the cucumber stack trace is too harsh to beginners.

## Main idea

```
Given I first installed cucumber and aruba
And I'm not an expert at debugging Ruby applications
And I make a typo in my step
And I want to check out the avaiable step definitions to see what my typo was
When I run `cucumber --format stepdefs`
Then the command should fail
And I shouldn't be shown a 40 line Ruby stack trace
And there should be a helpful error message that looks something like:
  """
  You can't use the `--format stepdefs` flag with undefined steps!
  Implement the steps and try again.

  You can implement step definitions for undefined steps with these snippets:

  Then("the command should pass with:") do |string|
    pending # Write code here that turns the phrase above into concrete actions
  end
  """

Or, the `--format stepdefs` should just work without needing to define all the steps before hand.
Or, there should be a feature to just preview all the steps.
Or, the `--dry-run` switch should work.
```

But right now the long stack trace doesn't help a beginner realize that the solution is to:

* remove the step
* comment out the step
* make a stub definition of the step

## Error reproduction steps

```
gem install cucumber:3.1.0 aruba:0.14.5
mkdir cukular_bomb
cd cukular_bomb/
cucumber --init
cat <<'EOF' > features/support/env.rb
require 'aruba/cucumber'
EOF
cat <<'EOF' > features/helloruby.feature
Feature: Ruby's command line interface
  Scenario: Using the -e flag
    When I run `ruby -e 'print "hello world!"'`
    Then the command should pass with:
      """
      hello world!
      """
EOF
cucumber
cucumber --format stepdefs
cucumber --format stepdefs 2>&1 | awk 'END { print NR }'
```

## Error example

```
cucumber --init
  create   features
  create   features/step_definitions
  create   features/support
  create   features/support/env.rb
cat <<'EOF' > features/support/env.rb
> require 'aruba/cucumber'
> EOF
$ cat <<'EOF' > features/helloruby.feature
> Feature: Ruby's command line interface
>   Scenario: Using the -e flag
>     When I run `ruby -e 'print "hello world!"'`
>     Then the command should pass with:
>       """
>       hello world!
>       """
> EOF
cucumber
Feature: Ruby's command line interface

  Scenario: Using the -e flag                   # features/helloruby.feature:2
    When I run `ruby -e 'print "hello world!"'` # aruba-0.14.5/lib/aruba/cucumber/command.rb:13
    Then the command should pass with:          # features/helloruby.feature:4
      """
      hello world!
      """

1 scenario (1 undefined)
2 steps (1 undefined, 1 passed)
0m0.115s

You can implement step definitions for undefined steps with these snippets:

Then("the command should pass with:") do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

cucumber --format stepdefs
.undefined method `step_definition' for nil:NilClass (NoMethodError)
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-3.1.0/lib/cucumber/formatter/usage.rb:41:in `on_test_step_finished'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/event_bus.rb:34:in `block in broadcast'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/event_bus.rb:34:in `each'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/event_bus.rb:34:in `broadcast'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/event_bus.rb:40:in `method_missing'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/runner.rb:35:in `around_hook'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/around_hook.rb:12:in `describe_to'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/case.rb:120:in `block (2 levels) in compose_around_hooks'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/case.rb:121:in `compose_around_hooks'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/case.rb:26:in `block in describe_to'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/runner.rb:19:in `test_case'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/case.rb:25:in `describe_to'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-3.1.0/lib/cucumber/filters/prepare_world.rb:12:in `test_case'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/case.rb:25:in `describe_to'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/filter.rb:57:in `test_case'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-3.1.0/lib/cucumber/filters/retry.rb:18:in `test_case'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/case.rb:25:in `describe_to'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-3.1.0/lib/cucumber/filters/quit.rb:12:in `test_case'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/case.rb:25:in `describe_to'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-3.1.0/lib/cucumber/filters/broadcast_test_run_started_event.rb:20:in `block in done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-3.1.0/lib/cucumber/filters/broadcast_test_run_started_event.rb:19:in `map'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-3.1.0/lib/cucumber/filters/broadcast_test_run_started_event.rb:19:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/filter.rb:62:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/filter.rb:62:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/filter.rb:62:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/filter.rb:62:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/filter.rb:62:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/filters/locations_filter.rb:20:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/filter.rb:62:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/filters/tag_filter.rb:18:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/compiler.rb:24:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/gherkin/parser.rb:37:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core.rb:32:in `parse'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core.rb:21:in `compile'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-3.1.0/lib/cucumber/runtime.rb:74:in `run!'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-3.1.0/lib/cucumber/cli/main.rb:33:in `execute!'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-3.1.0/bin/cucumber:9:in `<top (required)>'
/Users/mbigras/.gem/ruby/2.4.2/bin/cucumber:23:in `load'
/Users/mbigras/.gem/ruby/2.4.2/bin/cucumber:23:in `<main>'
cucumber --format stepdefs 2>&1 | awk 'END { print NR }'
40
```

Stack trace

```
.undefined method `step_definition' for nil:NilClass (NoMethodError)
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-3.1.0/lib/cucumber/formatter/usage.rb:41:in `on_test_step_finished'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/event_bus.rb:34:in `block in broadcast'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/event_bus.rb:34:in `each'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/event_bus.rb:34:in `broadcast'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/event_bus.rb:40:in `method_missing'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/runner.rb:35:in `around_hook'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/around_hook.rb:12:in `describe_to'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/case.rb:120:in `block (2 levels) in compose_around_hooks'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/case.rb:121:in `compose_around_hooks'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/case.rb:26:in `block in describe_to'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/runner.rb:19:in `test_case'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/case.rb:25:in `describe_to'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-3.1.0/lib/cucumber/filters/prepare_world.rb:12:in `test_case'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/case.rb:25:in `describe_to'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/filter.rb:57:in `test_case'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-3.1.0/lib/cucumber/filters/retry.rb:18:in `test_case'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/case.rb:25:in `describe_to'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-3.1.0/lib/cucumber/filters/quit.rb:12:in `test_case'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/case.rb:25:in `describe_to'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-3.1.0/lib/cucumber/filters/broadcast_test_run_started_event.rb:20:in `block in done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-3.1.0/lib/cucumber/filters/broadcast_test_run_started_event.rb:19:in `map'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-3.1.0/lib/cucumber/filters/broadcast_test_run_started_event.rb:19:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/filter.rb:62:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/filter.rb:62:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/filter.rb:62:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/filter.rb:62:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/filter.rb:62:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/filters/locations_filter.rb:20:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/filter.rb:62:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/test/filters/tag_filter.rb:18:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/compiler.rb:24:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core/gherkin/parser.rb:37:in `done'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core.rb:32:in `parse'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-core-3.1.0/lib/cucumber/core.rb:21:in `compile'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-3.1.0/lib/cucumber/runtime.rb:74:in `run!'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-3.1.0/lib/cucumber/cli/main.rb:33:in `execute!'
/Users/mbigras/.gem/ruby/2.4.2/gems/cucumber-3.1.0/bin/cucumber:9:in `<top (required)>'
/Users/mbigras/.gem/ruby/2.4.2/bin/cucumber:23:in `load'
/Users/mbigras/.gem/ruby/2.4.2/bin/cucumber:23:in `<main>'
```
