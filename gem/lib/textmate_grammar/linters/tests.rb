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
    def pre_lint(pattern, options)
        return true unless pattern.is_a? PatternBase

        pattern.resolve(options[:repository]).run_tests
    end
end

Grammar.register_linter(RunPatternTests.new)