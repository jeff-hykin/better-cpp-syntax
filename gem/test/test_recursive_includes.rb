# run 1-off with: bundle exec ruby "./gem/test/test_recursive_includes.rb"
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
        match: Pattern.new(/testing/),
        includes: [
            :thing1,
            Pattern.new(/other thing/),
        ]
    ),
])


expected_value = "[:abc, \"abc\", #<RepeatablePattern:0x00007fa22395ed28 match:\"abc\">, :thing1, #<RepeatablePattern:0x00007fa22395fa48 match:\"other thing\">, :thing1, #<RepeatablePattern:0x00007fa22395fa48 match:\"other thing\">]" 
if test_pat.recursive_includes.inspect.gsub(/0x[a-f0-9]+/,"") != expected_value.gsub(/0x[a-f0-9]+/,"")
    raise <<~HEREDOC
        
        
        Failed test in #{__FILE__}:#{__LINE__}
    HEREDOC
end