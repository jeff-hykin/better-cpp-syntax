# frozen_string_literal: true
require 'ruby_grammar_builder'
require 'walk_up'
require_relative walk_up_until("paths.rb")

export = Grammar.new_exportable_grammar
export.external_repos = [] # patterns that are imported
export.exports = [ # patterns that are exported
    :string,
]
# (other :patterns can be created and used, but they will be namespace-randomized to keep them from ever conflicting/overwriting external patterns)

escape_pattern = Pattern.new(
    match: /\\./,
    tag_as: "constant.character.escape"
)

export[:string] = PatternRange.new(
    start_pattern: Pattern.new(
        match: /"/,
        tag_as: "punctuation.definition.string"
    ),
    end_pattern: Pattern.new(
        match: /"/,
        tag_as: "punctuation.definition.string"
    ),
    includes: [
        escape_pattern
    ],
)