# frozen_string_literal: true

require_relative 'test_helper'

class SubPatternTest < MiniTest::Test
    def test_maybe
        r = Pattern.new(
            match: "abc",
        ).maybe(/def/).to_r

        assert_match r, "abc"
        assert_match r, "abcdef"
        refute_match r, "def"
    end

    def test_zeroOrMoreOf
        r = wrap_complete(zeroOrMoreOf("abc")).to_r

        assert_match r, ""
        assert_match r, "abc"
        assert_match r, ("abc" * rand(100))
        refute_match r, "d"
        refute_match r, ("abc" * rand(100)) + "d"
    end

    def test_oneOrMoreOf
        r = wrap_complete(oneOrMoreOf("abc")).to_r

        refute_match r, ""
        assert_match r, "abc"
        assert_match r, ("abc" * rand(100))
        refute_match r, "d"
        refute_match r, ("abc" * rand(100)) + "d"
    end

    def test_or
        r = wrap_complete(Pattern.new("abc").or("def")).to_r

        refute_match r, ""
        assert_match r, "abc"
        assert_match r, "def"
        refute_match r, "abcdef"
    end

    def test_oneOf
        r = wrap_complete(oneOf(["abc", "def"])).to_r

        refute_match r, ""
        assert_match r, "abc"
        assert_match r, "def"
        refute_match r, "abcdef"
    end

    def test_lookAheadFor
        r = Pattern.new("abc").lookAheadFor("def").to_r

        refute_match r, ""
        refute_match r, "abc"
        refute_match r, "def"
        refute_match r, "abcabc"
        assert_match r, "abcdef"
        refute_match r, "defabc"
        refute_match r, "defdef"
    end

    def test_lookAheadToAvoid
        r = Pattern.new("abc").lookAheadToAvoid("def").to_r

        refute_match r, ""
        assert_match r, "abc"
        refute_match r, "def"
        assert_match r, "abcabc"
        refute_match r, "abcdef"
        assert_match r, "defabc"
        refute_match r, "defdef"
    end

    def test_lookBehindFor
        r = lookBehindFor("abc").then("def").to_r

        refute_match r, ""
        refute_match r, "abc"
        refute_match r, "def"
        refute_match r, "abcabc"
        assert_match r, "abcdef"
        refute_match r, "defabc"
        refute_match r, "defdef"
    end

    def test_lookBehindToAvoid
        r = lookBehindToAvoid("abc").then("def").to_r

        refute_match r, ""
        refute_match r, "abc"
        assert_match r, "def"
        refute_match r, "abcabc"
        refute_match r, "abcdef"
        assert_match r, "defabc"
        assert_match r, "defdef"
    end

    def test_backreferences
        r1 = wrap_complete(
            Pattern.new(
                match: /[a-z]\d/,
                reference: "part1",
            ).matchResultOf("part1"),
        ).to_r

        r2 = wrap_complete(
            matchResultOf("part2").then(
                match: /[a-z]\d/,
                reference: "part2",
            ),
        ).to_r

        refute_match r1, ""
        refute_match r2, ""
        refute_match r1, "a1"
        refute_match r2, "b2"
        refute_match r1, "a1b2"
        refute_match r2, "b2a1"
        assert_match r1, "a1a1"
        refute_match r2, "b2b2" # forward references do not work
    end

    def test_subexp
        r = wrap_complete(
            Pattern.new(
                match: Pattern.new("(").then(/\s*/).then(/\w+/).zeroOrMoreOf(
                    Pattern.new(/\s+/).oneOf(
                        [
                            Pattern.new(/\w+/),
                            recursivelyMatch("func_call"),
                        ],
                    ),
                ).then(/\s*/).then(")"),
                reference: "func_call",
            ),
        ).to_r

        refute_match r, ""
        refute_match r, "()"
        assert_match r, "(func1)"
        assert_match r, "(func1 arg1 (func2 arg2 arg3 (func3 ( func4 arg4))))"
    end
end