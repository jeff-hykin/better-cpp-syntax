# frozen_string_literal: true

require_relative 'test_helper'

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

    def test_missing
        assert_output(/Missing one or more of the required grammar keys/) do
            err = assert_raises RuntimeError do
                Grammar.new(
                    name: "test",
                )
            end
            assert_match "See above error", err.message
        end
    end

    def test_empty_grammar
        g = test_grammar

        expected = {
            name: "test",
            scopeName: "source.test",
            repository: {},
            patterns: [],
            version: "",
        }
        assert_equal expected, g.generate
    end

    def test_bad_key
        g = test_grammar

        assert_output(/repository names starting with \$ are reserved/) do
            err = assert_raises RuntimeError do
                g[:$bad_key] = "abc"
            end
            assert_match "See above error", err.message
        end

        assert_output(/the name 'repository' is a reserved name/) do
            err = assert_raises RuntimeError do
                g[:repository] = "abc"
            end
            assert_match "See above error", err.message
        end

        err = assert_raises RuntimeError do
            g["string_key"] = "abc"
        end
        assert_match "Use symbols not strings", err.message
    end

    def test_import
        import_path = File.join(__dir__, "fixtures", "import.tmLanguage.json")
        g = Grammar.fromTmLanguage(import_path)

        err = assert_raises RuntimeError do
            g[:def]
        end
        assert_match "def is a not a pattern and cannot be referenced", err.message

        g[:def] = /def/

        assert_kind_of(PatternBase, g[:def])

        g.save_to(
            generate_tags: false,
            syntax_dir: ".",
            syntax_name: "import.export",
        )

        assert_equal JSON.parse(File.read(import_path)), JSON.parse(File.read("import.export.json"))
    ensure
        File.delete("import.export.json") if File.exist?("import.export.json")
    end

    def test_export
        eg = Grammar.new_exportable_grammar
        eg.exports = [:abc]
        eg[:abc] = "abc"
        eg[:def] = "def"
        g = test_grammar
        g.import(eg)
        expected = {
            :name => "test",
            :scopeName => "source.test",
            :repository => {
                :abc => {:match => "abc"},
                :"0f591ced18d_def" => {:match => "def"},
            },
            :patterns => [],
            :version => "",
        }
        assert_equal expected, g.generate
    end

    def test_initial_context
        g = test_grammar
        g[:abc] = PatternRange.new(
            start_pattern: /abc/,
            end_pattern: /def/,
            includes: [:$initial_context],
        )
        expected = {
            :name => "test",
            :scopeName => "source.test",
            :patterns => [],
            :repository => {
                :abc => {
                    "begin" => "abc",
                    "end" => "def",
                    "beginCaptures" => {},
                    "endCaptures" => {},
                    :patterns => [{ :include => "$self" }],
                },
            },
            :version => "",
        }

        assert_equal expected, g.generate
    end
end