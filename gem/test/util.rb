require 'textmate_grammar'

def test_grammar
    Grammar.new(
        name: "test",
        scope_name: "source.test",
        version: ""
    )
end