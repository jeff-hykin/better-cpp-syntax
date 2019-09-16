# frozen_string_literal: true

class GrammarLinter
    # runs a linter on each pattern
    # returns false if linting failed
    # pattern may be a (Pattern, Symbol, or Hash)
    def pre_lint(key, pattern)
        true
    end

    # runs a linter on the entire grammar
    # returns false if linting failed
    def post_lint(grammar_hash)
        true
    end
end