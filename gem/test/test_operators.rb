# frozen_string_literal: true

require_relative 'test_helper'
require 'textmate_grammar/regex_operator'
require 'textmate_grammar/regex_operators/concat'
require 'textmate_grammar/regex_operators/alternation'

class OperatorTest < MiniTest::Test
    def test_noop
        arr = ['A']
        assert_equal 'A', RegexOperator.evaluate(arr)
    end

    def test_concat
        arr = ['A', ConcatOperator.new, 'B']
        assert_equal 'AB', RegexOperator.evaluate(arr)
        arr = [
            'A',
            ConcatOperator.new,
            'B',
            ConcatOperator.new,
            'C',
            ConcatOperator.new,
            'D',
            ConcatOperator.new,
            'E',
        ]
        assert_equal 'ABCDE', RegexOperator.evaluate(arr)
    end

    def test_alternation
        arr = ['A', AlternationOperator.new, 'B']
        assert_equal '(?:A|B)', RegexOperator.evaluate(arr)

        arr = [
            'A',
            AlternationOperator.new,
            'B',
            AlternationOperator.new,
            'C',
            AlternationOperator.new,
            'D',
            AlternationOperator.new,
            'E',
        ]
        assert_equal '(?:(?:(?:(?:A|B)|C)|D)|E)', RegexOperator.evaluate(arr)
    end

    def test_combine
        arr = ['A', ConcatOperator.new, 'B', AlternationOperator.new, 'CD', ConcatOperator.new, 'E']
        assert_equal '(?:AB|CD)E', RegexOperator.evaluate(arr)
    end

    def test_complex
        # equivlent to Pattern.new("A").then("B").or("C").then("D").or("E")
        arr = [
            'A',
            ConcatOperator.new,
            'B',
            AlternationOperator.new,
            'C',
            ConcatOperator.new,
            'D',
            AlternationOperator.new,
            'E',
        ]
        assert_equal '(?:(?:AB|C)D|E)', RegexOperator.evaluate(arr)
    end
end