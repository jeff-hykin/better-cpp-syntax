# frozen_string_literal: true

require_relative 'test_helper'

class RepeatedTagAsTest < MiniTest::Test
    def test_repeated_tag_as
        g = test_grammar

        g[:abc] = oneOrMoreOf(
            match: Pattern.new(
                match: /abc\s/,
                tag_as: "abc",
            ),
        )

        g[:def] = oneOrMoreOf(
            match: /def\s/,
            tag_as: "def",
        )

        expected = {
            :abc => {
                :match => "(?:abc\\s)+",
                :captures => {
                    "0" => {
                        :patterns => [
                            {
                                :match => "abc\\s",
                                :name => "abc.test",
                            },
                        ],
                    },
                },
            },
            :def => {
                :match => "(?:def\\s)+",
                :name => "def.test",
            },
        }

        assert_equal expected, g.generate[:repository]
    end
end