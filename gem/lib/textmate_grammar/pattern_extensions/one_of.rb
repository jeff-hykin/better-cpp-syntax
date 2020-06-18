# frozen_string_literal: true

# Provides alternation
# when one of the passed in patterns is accepted, this pattern is accepted
class OneOfPattern < PatternBase
    # create a new OneOfPattern
    # this is expects an array of patterns

    #
    # Create a new OneOfPattern
    #
    # @param [Array<PatternBase,Regexp,String>] patterns a list of patterns to match
    #
    def initialize(patterns, deep_clone = nil, original_arguments = nil)
        if deep_clone == :deep_clone
            super(patterns, deep_clone, original_arguments)
            return
        end
        unless patterns.is_a? Array
            raise <<~HEREDOC
                oneOf() expects an array of patterns, the provided argument is not an array.
                The arguments to oneOf is below
                #{patterns}
            HEREDOC
        end
        super(
            match: "one of",
            patterns: patterns.map do |pattern|
                next pattern if pattern.is_a? PatternBase

                PatternBase.new(pattern)
            end
        )
    end

    # (see PatternBase#generate_self_regex_string)
    def generate_self_regex_string(groups)
        patterns_strings = @arguments[:patterns].map do |pattern|
            regex = pattern.evaluate(groups)
            # if it is known to be a single entity, then no need to wrap it
            next regex if pattern.single_entity? || regex.to_s =~ /^[\w\s]*$/
            
            "(?:#{regex})"
        end

        return "(#{patterns_strings.join '|'})" if needs_to_capture?

        "(?:#{patterns_strings.join '|'})"
    end

    # (see PatternBase#do_collect_self_groups)
    def do_collect_self_groups(next_group)
        groups = []
        @arguments[:patterns].each do |pattern|
            pat_groups = pattern.collect_group_attributes(next_group)
            groups.concat(pat_groups)
            next_group += pat_groups.length
        end
        groups
    end

    # (see PatternBase#single_entity?)
    # @return [true]
    def single_entity?
        true
    end
    
    # (see PatternBase#recursive_pattern_chain)
    def recursive_pattern_chain
        pattern_aggregation = super()
        # add the @arguments[:patterns] (recursively) to the front
        front_pattern_aggregation = []
        for each in @arguments[:patterns]
            front_pattern_aggregation.push(each)
            front_pattern_aggregation += each.recursive_pattern_chain if each.is_a?(PatternBase)
        end 
        pattern_aggregation = front_pattern_aggregation + pattern_aggregation
        return pattern_aggregation
    end
    
    # (see PatternBase#recursive_includes)
    def recursive_includes
        aggregation_of_includes = super()
        # add the @arguments[:patterns] (recursively) to the front
        front_include_aggregation = []
        for each in @arguments[:patterns]
            if each.is_a?(PatternBase)
                front_include_aggregation += each.arguments[:includes] if each.arguments[:includes].is_a?(Array)
                front_include_aggregation += each.recursive_includes
            end
        end 
        aggregation_of_includes = front_include_aggregation + aggregation_of_includes
        return aggregation_of_includes
    end
    
    def map!(map_includes = false, &block)
        @arguments[:patterns].map! { |p| p.map!(map_includes, &block) }
        @next_pattern.map!(map_includes, &block) if @next_pattern.is_a? PatternBase
        map_includes!(&block) if map_includes
        self
    end

    # (see PatternBase#to_s)
    def to_s(depth = 0, top_level = true)
        indent = "  " * depth
        output = top_level ? "oneOf([" : ".oneOf(["
        output += "\n#{indent}  "
        output += (@arguments[:patterns].map do |pattern|
            pattern.to_s(depth + 1, true).lstrip
        end).join ",\n#{indent}  "
        output += "\n#{indent}])"
        output += @next_pattern.to_s(depth, false).lstrip if @next_pattern
        output
    end
end

class PatternBase
    #
    # Match one of the supplied patterns
    #
    # @param [Array<PatternBase,Regexp,String>] patterns a list of patterns to match
    #
    # @return [PatternBase] a pattern to append to
    #
    def oneOf(patterns)
        insert(OneOfPattern.new(patterns))
    end
end

#
# (see PatternBase#oneOf)
#
def oneOf(patterns)
    OneOfPattern.new(patterns)
end