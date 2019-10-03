# frozen_string_literal: true

require_relative 'test_helper'

class NestedEndingTest < MiniTest::Test
    def test_nested_ending
        g = test_grammar

        g[:abc] = Pattern.new(
            match: "abc",
            tag_as: "abc",
            includes: [
                Pattern.new(match: "def", tag_as: "d e f"),
                Pattern.new(match: "def", tag_as: "g h i"),
            ],
        )

        expected = {
            :abc => {
                :match => "abc",
                :captures => {
                    "0" => {
                        :patterns => [
                            {
                                :match => "def",
                                :name => "d.test e.test f.test",
                            },
                            {
                                :match => "def",
                                :name => "g.test h.test i.test",
                            },
                        ],
                    },
                },
                :name => "abc.test",
            },
        }
        assert_equal expected, g.generate[:repository]
    end
end