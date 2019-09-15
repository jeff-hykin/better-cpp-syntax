require_relative 'base'

class RunPatternTests < GrammarLinter
    def pre_lint(key, pattern)
        return pattern.run_tests if pattern.is_a? Pattern
        true
    end
end

Grammar.register_linter(RunPatternTests.new())