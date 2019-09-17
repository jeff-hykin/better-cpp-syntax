# frozen_string_literal: true

require_relative 'lib/textmate_grammar'
require 'pp'

test_pat = Pattern.new(
    match: Pattern.new(/abc\w/).then(match: /aaa/, tag_as: "part1.part2.$reference(ghi)"),
    tag_as: "part1",
    reference: "abc",
    includes: [
        :abc,
        "abc",
        Pattern.new(match: /abc/, tag_as: "abc123"),
    ],
).maybe(/def/).then(
    match: /ghi/,
    tag_as: "part2",
    reference: "ghi",
).lookAheadFor(/jkl/).matchResultOf("abc").recursivelyMatch("ghi").or(
    match: /optional/,
    tag_as: "variable.optional.$match",
)
# puts test_pat.evaluate
pp test_pat.reTag(
    "part2" => "part3",
).to_tag

# puts test_pat.groupless.to_r

test_range = PatternRange.new(
    start_pattern: /abc/,
    tag_start_as: "abc",
    end_pattern: /def/,
)

puts test_range
# puts test_range.to_tag

# grammar = Grammar.new_exportable_grammar
# puts grammar