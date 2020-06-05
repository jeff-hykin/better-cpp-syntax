# run 1-off with: bundle exec ruby "./gem/test/test_recursive_pattern_chain.rb"
require_relative '../lib/textmate_grammar'
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
).oneOf([
    /hi/,
    Pattern.new(/hello/),
    Pattern.new(
        match: Pattern.new(/testing/)
    ),
])


expected_value = "[#<RepeatablePattern:0x00007f8f8d906450 match:\"abc\\\\w\">, #<RepeatablePattern:0x00007f8f8d906310 match:\"aaa\">, #<MaybePattern:0x00007f8f8d906108 match:\"def\">, #<RepeatablePattern:0x00007f8f8d905fa0 match:\"ghi\">, #<LookAroundPattern:0x00007f8f8d905e88 match:\"jkl\">, #<MatchResultOfPattern:0x00007f8f8d905de8 match:\"(?#[:backreference:abc:])\">, #<RecursivelyMatchPattern:0x00007f8f8d905d70 match:\"(?#[:subroutine:ghi:])\">, #<OrPattern:0x00007f8f8d905cf8 match:\"optional\">, #<OneOfPattern:0x00007f8f8d906ab8 match:\"one\\\\ of\">, #<PatternBase:0x00007f8f8d906a68 match:\"hi\">, #<RepeatablePattern:0x00007f8f8d9075f8 match:\"hello\">, #<RepeatablePattern:0x00007f8f8d906bf8 match:#<RepeatablePattern:0x00007f8f8d9070a8 match:\"testing\">>, #<RepeatablePattern:0x00007f8f8d9070a8 match:\"testing\">]" 
if test_pat.recursive_pattern_chain.inspect.gsub(/0x[a-f0-9]+/,"") != expected_value.gsub(/0x[a-f0-9]+/,"")
    raise <<~HEREDOC
        
        
        Failed test in #{__FILE__}:#{__LINE__}
    HEREDOC
end