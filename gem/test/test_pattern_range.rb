# frozen_string_literal: true

require_relative 'test_helper'

class PatternRangeTest < MiniTest::Test
    def test_bad_initialize
        err = assert_raises RuntimeError do
            PatternRange.new("abc")
        end
        assert_match "PatternRange.new() expects a hash", err.message

        err = assert_raises RuntimeError do
            PatternRange.new(
                start_pattern: "abc",
            )
        end
        assert_match "one of `while_pattern:` or `end_pattern` must be supplied", err.message

        err = assert_raises RuntimeError do
            PatternRange.new(
                start_pattern: "abc",
                while_pattern: "abc",
                end_pattern: "abc",
            )
        end
        assert_match "only one of `while_pattern:` or `end_pattern` must be supplied", err.message
    end

    def test_zero_length
        g = test_grammar
        g[:test] = PatternRange.new(
            start_pattern: maybe("abc"),
            end_pattern: "def",
        )
        assert_output(/Warning: \(\?:abc\)\?\nmatches the zero length string \(""\)\./) do
            g.generate
        end
    end

    def test_zero_disable_length
        g = test_grammar
        g[:test] = PatternRange.new(
            start_pattern: Pattern.new(/\G/).maybe("abc"),
            end_pattern: "def",
        )
        g[:test2] = PatternRange.new(
            start_pattern: maybe("abc"),
            end_pattern: "def",
            zeroLengthStart?: true,
        )
        assert_silent do
            g.generate
        end
    end

    def test_pattern_range_not_composable
        pr = PatternRange.new(
            start_pattern: "abc",
            while_pattern: "def",
        )
        err = assert_raises RuntimeError do
            Pattern.new("abc").then(pr).evaluate
        end

        assert_match "PatternRange cannot be used as a part of a Pattern", err.message
    end

    def test_tag_as
        pr = PatternRange.new(
            start_pattern: "abc",
            tag_start_as: "abc",
            end_pattern: "abc",
            tag_end_as: "abc",
            tag_as: "abc",
            tag_content_as: "abc",
        ).to_tag
        expected = {
            "begin" => "abc",
            "end" => "abc",
            "beginCaptures" => {"0" => {:name => "abc"}},
            "endCaptures" => {"0" => {:name => "abc"}},
            :name => "abc",
            :contentName => "abc",
        }

        assert_equal expected, pr
    end
end