# frozen_string_literal: true

require_relative 'test_helper'

class PlaceholderPatternTest < MiniTest::Test
    def test_placeholder
        g = test_grammar

        g[:abc] = oneOrMoreOf(g[:def])
        g[:def] = oneOrMoreOf(g[:ghi])
        g[:ghi] = "ghi"

        expected = {
            :abc => { :match => "(?:(?:ghi)+)+" },
            :def => { :match => "(?:ghi)+" },
            :ghi => { :match => "ghi" },
        }
        assert_equal expected, g.generate[:repository]
    end
end