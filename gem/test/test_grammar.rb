# frozen_string_literal: true

require 'minitest/autorun'
require 'textmate_grammar'

class GrammarTest < MiniTest::Test
    def test_source
        assert_silent do
            Grammar.new(
                name: "test",
                scope_name: "source.test",
            )
        end
    end

    def test_text
        assert_silent do
            Grammar.new(
                name: "test",
                scope_name: "text.test",
            )
        end
    end

    def test_other
        assert_output(/Warning: grammar scope name/) do
            Grammar.new(
                name: "test",
                scope_name: "test",
            )
        end
    end

    def test_empty_grammar
        g = Grammar.new(
            name: "test",
            scope_name: "text.test",
            version: "",
        )
        expected = {
            name: "test",
            scopeName: "text.test",
            repository: {},
            patterns: [],
            version: "",
        }
        assert_equal expected, g.generate
    end

    def test_import
        import_path = File.join(__dir__, "fixtures", "import.tmLanguage.json")
        g = Grammar.fromTmLanguage(import_path)

        err = assert_raises RuntimeError do
            g[:def]
        end
        assert_match "def is a not a Pattern and cannot be referenced", err.message

        g[:def] = /def/

        assert_kind_of(Pattern, g[:def])

        g.save_to(
            generate_tags: false,
            syntax_dir: ".",
            syntax_name: "import.export",
        )

        assert_equal JSON.parse(File.read(import_path)), JSON.parse(File.read("import.export.json"))
    ensure
        File.delete("import.export.json") if File.exist?("import.export.json")
    end
end