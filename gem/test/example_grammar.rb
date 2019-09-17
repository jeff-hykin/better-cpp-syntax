# frozen_string_literal: true

require_relative '../lib/textmate_grammar'

ex = Grammar.new_exportable_grammar

ex.exports = [
    :abc,
]

ex.external_repos = [
    :p123,
]

ex[:abc] = Pattern.new(
    match: /abc/,
    tag_as: "abc",
    includes: [
        :p123,
        :test_pat,
        :$initial_context,
    ],
)

ex[:test_pat] = /abcd/

g = Grammar.new(
    name: "example",
    scope_name: "source.example",
)

ex.export # just to confirm that export is idempotent

g.import(ex.export)
g[:$initial_context] = [
    Pattern.new(
        match: "def",
        tag_as: "abc def",
    ),
    :abc,
]

g.save_to "."