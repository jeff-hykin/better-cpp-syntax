# frozen_string_literal: true

#
# Runs the unit tests on each pattern
#
class RunPatternTests < GrammarLinter
    def pre_lint(key, pattern)
        return pattern.run_tests if pattern.is_a? Pattern
        true
    end
end

Grammar.register_linter(RunPatternTests.new())