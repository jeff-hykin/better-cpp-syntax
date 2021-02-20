# frozen_string_literal: true

#
# Runs the unit tests on each pattern
#
class RunPatternTests < GrammarLinter
    #
    # Runs the unit tests on each pattern
    #
    # @return [Boolean] the result of the unit tests
    #
    def pre_lint(pattern, _options)
        return true unless pattern.is_a? PatternBase

        pattern.run_tests
    end
end

Grammar.register_linter(RunPatternTests.new)