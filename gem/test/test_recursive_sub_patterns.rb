# run 1-off with: bundle exec ruby "./gem/test/test_recursive_sub_patterns.rb"
require_relative '../lib/textmate_grammar'
require 'pp'

test_pat = Pattern.new(
    match: Pattern.new(/abc1\w/).then(match: /aaa/, tag_as: "part1.part2.$reference(ghi)"),
    tag_as: "part1",
    reference: "abc2",
    includes: [
        :abc3,
        "abc4",
        Pattern.new(match: /abc5/, tag_as: "abc123"),
    ],
).maybe(/def/).then(
    match: /ghi/,
    tag_as: "part2",
    reference: "ghi",
).lookAheadFor(/jkl/).matchResultOf("abc6").recursivelyMatch("ghi").or(
    match: /optional/,
    tag_as: "variable.optional.$match",
).oneOf([
    /hi/,
    Pattern.new(/hello/),
    Pattern.new(
        match: Pattern.new(/testing/)
    ),
])

require 'fiddle'

# 
# map
# 
class Object
  def unfreeze
    Fiddle::Pointer.new(object_id * 2)[1] &= ~(1 << 3)
  end
end

test_pat.unfreeze
aggregate_patterns_from_map = []
test_pat.map!(true) do |each|
    aggregate_patterns_from_map.push(each)
    each
end
aggregate_patterns_from_map

# 
# recursive_sub_patterns
# 
map_equivlent = test_pat.recursive_sub_patterns.select{|each| !(each.is_a?(OneOfPattern)||each.is_a?(Symbol)||each.is_a?(String))} << test_pat

#
# compare
#  
map_equivlent.map!(&:inspect)
aggregate_patterns_from_map.map!(&:inspect)
if !( (aggregate_patterns_from_map - map_equivlent).size == 0 && (map_equivlent - aggregate_patterns_from_map).size == 0 )
    raise <<~HEREDOC
        
        
        Failed test in #{__FILE__}:#{__LINE__}
    HEREDOC
end