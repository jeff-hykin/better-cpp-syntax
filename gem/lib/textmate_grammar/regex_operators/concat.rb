# frozen_string_literal: true

require_relative '../regex_operator'

#
# The standard RegexOperator, provides concatination
#
class ConcatOperator < RegexOperator
    def initialize
        @precedence = 2
        @association = :left
    end

    # (see RegexOperator#do_evaluate_self)
    def do_evaluate_self(arr_left, arr_right)
        left = fold_left(arr_left)
        right = fold_right(arr_right)

        self_string = left[0]+right[0]

        [left[1], self_string, right[1]].flatten
    end
end