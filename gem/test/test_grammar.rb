require 'minitest/autorun'
require 'textmate_grammar'

class GrammarTest < MiniTest::Test
    def test_source
        assert_silent() do
            Grammar.new(
                name: "test",
                scope_name: "source.test"
            )
        end
    end

    def test_text
        assert_silent() do
            Grammar.new(
                name: "test",
                scope_name: "text.test"
            )
        end
    end

    def test_other
        assert_output(/Warning: grammar scope name/) do
            Grammar.new(
                name: "test",
                scope_name: "test"
            )
        end
    end

    def test_empty_grammar
        g = Grammar.new(
            name: "test",
            scope_name: "text.test",
            version: ""
        )
        expected = {
            name: "test",
            scopeName: "text.test",
            repository: {},
            patterns: [],
            version: ""
        }
        assert_equal expected, g.generate
    end
end