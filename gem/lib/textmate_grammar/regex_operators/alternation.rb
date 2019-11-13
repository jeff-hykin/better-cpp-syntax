# frozen_string_literal: true

require_relative '../regex_operator'

#
# Provides alternation as described by OrPattern
#
class AlternationOperator < RegexOperator
    def initialize
        @precedence = 1
        @association = :right
    end

    # (see RegexOperator#do_evaluate_self)
    def do_evaluate_self(arr_left, arr_right)
        left = fold_left(arr_left)
        # fold right is not applied as only the immediate right is a part of the alternation
        # (?:#{foo}) is not needed as alternation has the lowest precedence (in regex)
        # that could be generated (anything lower is required to be closed)
        self_string = "(?:#{left[0]}|#{arr_right[0]})"

        [left[1], self_string, arr_right[1..-1]].flatten
    end
end