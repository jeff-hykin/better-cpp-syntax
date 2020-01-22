# frozen_string_literal: true

class UnusedUnresolvedLinter < GrammarLinter
    def post_lint(grammar_hash)
        true
    end
end

Grammar.register_linter(UnusedUnresolvedLinter.new)