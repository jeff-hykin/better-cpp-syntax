# frozen_string_literal: true

require_relative 'test_helper'

class MissingDisplayOptions < GrammarPlugin
    def self.options
        [:optionA]
    end
end

class NoOptions < GrammarPlugin
end

class GrammarPluginTest < MiniTest::Test
    def test_IE_message
        err = assert_raises RuntimeError do
            NoOptions.display_options("  ", {})
        end
        assert_match(
            "Internal error: display_options called with no provided options",
            err.message,
        )

        err = assert_raises RuntimeError do
            NoOptions.display_options("  ", optionA: "a")
        end
        assert_match(
            "Internal error: display_options called on a plugin that provides no options",
            err.message,
        )
    end

    def test_missing_display_options
        err = assert_raises RuntimeError do
            MissingDisplayOptions.display_options("  ", optionA: "a")
        end
        assert_match(
            "GrammarPlugin::options implemented but GrammarPlugin::display_options has not been",
            err.message,
        )
    end
end