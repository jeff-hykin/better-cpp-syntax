require_relative 'grammar'

ex = Grammar.new_exportable_grammar

ex.exports = [
    :abc,
]

ex.external_repos = [
    :p123,
]

ex[:abc] = Pattern.new(
    match: /abc/,
    includes: [
        :p123,
        :test_pat,
        :$initial_context,
    ]
)

ex[:test_pat] = /abcd/

g = Grammar.new(
    "test",
    "source.test",
)

ex.export

g.import(ex.export)

g.debug