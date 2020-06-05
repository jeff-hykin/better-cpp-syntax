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
)


expected_value = "[#<RepeatablePattern:0x00007f7fc08b3340 match:\"abc\\\\w\">, #<RepeatablePattern:0x00007f7fc08b31d8 match:\"aaa\">, #<MaybePattern:0x00007f7fc08b2cb0 match:\"def\">, #<RepeatablePattern:0x00007f7fc08b2a80 match:\"ghi\">, #<LookAroundPattern:0x00007f7fc08b27d8 match:\"jkl\">, #<MatchResultOfPattern:0x00007f7fc08b26e8 match:\"(?#[:backreference:abc:])\">, #<RecursivelyMatchPattern:0x00007f7fc08b2620 match:\"(?#[:subroutine:ghi:])\">, #<OrPattern:0x00007f7fc08b3908 match:\"optional\">]"
if test_pat.recursive_pattern_chain.inspect.gsub(/0x[a-f0-9]+/,"") != expected_value.gsub(/0x[a-f0-9]+/,"")
    raise <<~HEREDOC
        
        
        Failed test in #{__FILE__}:#{__LINE__}
    HEREDOC
end