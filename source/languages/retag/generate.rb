require_relative '../../../directory'
require_relative PathFor[:repo_helper]
require_relative PathFor[:textmate_tools]

retag = Grammar.new(
    name: "retag",
    scope_name: "source.retag",
)

retag[:$initial_context] = [
    :original
]

retag[:original] = original = newPattern(
    match: /new/.then(
        match: /\s?pattern/,
        tag_as: "entity.name.inner",
        reference: "inner"
    ).then(
        match: /\s?test/,
        reference: "bar"
    ),
    tag_as: "entity.name.outer"
)

retag[:new] = original.reTag(
    "entity.name.inner" => "entity.name.retagged",
    "all" => true
)

puts "Original"
p retag[:original]
p retag[:original].captures
p retag[:original].group_attributes
puts ""
puts "New"
p retag[:new]
p retag[:new].captures
p retag[:new].group_attributes

saveGrammar(retag)