# frozen_string_literal: true

require 'simplecov'
require 'simplecov-lcov'

# SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter

SimpleCov::Formatter::LcovFormatter.config do |c|
    c.output_directory = 'coverage'
    c.lcov_file_name = 'lcov.info'
    c.report_with_single_file = true
end

SimpleCov.start do
    track_files "{lib}/**/*.rb"
    add_filter '/test/' # for minitest
end

require 'minitest/autorun'
require 'textmate_grammar'

Grammar.remove_plugin(StandardNaming)

def test_grammar
    Grammar.new(
        name: "test",
        scope_name: "source.test",
        version: "",
    )
end

alias wrap_complete wrap_with_anchors