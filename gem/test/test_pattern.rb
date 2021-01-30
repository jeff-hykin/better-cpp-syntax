# frozen_string_literal: true

require_relative 'test_helper'

class PatternTest < MiniTest::Test
    def test_initializer
        assert_equal "abc", Pattern.new("abc").evaluate
        assert_equal "^abc$", Pattern.new(/^abc$/).evaluate
        assert_equal "\\^abc\\$", Pattern.new("^abc$").evaluate
        assert_equal "abc", Pattern.new(Pattern.new("abc")).evaluate
    end

    def test_needs_to_capture
        assert_equal false, Pattern.new("abc").needs_to_capture?
        assert_equal true, Pattern.new(match: "abc", tag_as: "abc").needs_to_capture?
        assert_equal true, Pattern.new(match: "abc", reference: "abc").needs_to_capture?
        assert_equal true, Pattern.new(match: "abc", includes: [:abc]).needs_to_capture?
    end

    def test_evaluate
        r = Pattern.new(
            match: "abc",
        ).to_r

        assert_match r, "abc"
    end

    def test_chaining
        r = Pattern.new(
            match: "abc",
        ).then(/def/).to_r

        assert_match r, "abcdef"
    end

    def test_arbitrary_quantifier
        r = wrap_complete(
            Pattern.new(
                match: /abc/,
                at_least: 3.times,
                at_most: 5.times,
            ),
        ).to_r

        refute_match r, ""
        refute_match r, "abc"
        assert_match r, "abcabcabc"
        assert_match r, "abcabcabcabc"
        assert_match r, "abcabcabcabcabc"
        refute_match r, "abcabcabcabcabcabc"
    end

    def test_to_s
        s = Pattern.new(
            match: oneOrMoreOf(lookAheadFor(/abc/)),
            at_least: 3.times,
            at_most: 5.times,
            should_not_fully_match: ["abc"],
        ).to_s
        result = <<-HEREDOC.remove_indent.rstrip
        Pattern.new(
          match: oneOrMoreOf(
              match: lookAround(
                  match: /abc/,
                  type: :lookAheadFor,
                ),
            ),
          should_not_fully_match: [\"abc\"],
          at_least: 3.times,
          at_most: 5.times,
        )
        HEREDOC
        assert_equal result, s
    end

    def test_simple_include
        g = test_grammar
        g[:abc] = Pattern.new(match: /abc/, includes: ["source.foo"])
        g[:def] = Pattern.new(match: /abc/, includes: "source.foo")
        e = g.generate
        assert_equal e[:repository][:abc], e[:repository][:def]
    end
end