# frozen_string_literal: true

require_relative 'test_helper'

class IssueTest < MiniTest::Test
    def test_0
        end_of_line = oneOf(
            [
                Pattern.new(/\n/),
                Pattern.new(/$/),
            ],
        )

        g = test_grammar
        g[:comment] = Pattern.new(
            match: Pattern.new(/[\\@]\S++/).lookAheadToAvoid(end_of_line),
            tag_as: "invalid.unknown.documentation.command",
        )
        g.generate
    end
end