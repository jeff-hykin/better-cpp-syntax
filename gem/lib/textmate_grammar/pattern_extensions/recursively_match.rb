# frozen_string_literal: true

#
# Implements subexp calls
# for some group N whose reference is "foo"
# recursivelyMatch("foo") results in the pattern /\gN/
#
class RecursivelyMatchPattern < PatternBase
    def initialize(reference, deep_clone = nil, original_arguments = nil)
        if reference.is_a? String
            super(
                match: Regexp.new("(?#[:subroutine:#{reference}:])"),
                subroutine_key: reference
            )
        else
            # most likely __deep_clone__ was called, just call the super initializer
            super(reference, deep_clone, original_arguments)
        end
    end

    # (see PatternBase#to_s)
    def to_s(depth = 0, top_level = true)
        output = top_level ? "recursivelyMatch(" : ".recursivelyMatch("
        output += "\"#{@arguments[:subroutine_key]}\")"
        output += @next_pattern.to_s(depth, false).lstrip if @next_pattern
        output
    end

    # (see PatternBase#single_entity?)
    # @return [true]
    def single_entity?
        true
    end

    # (see PatternBase#self_scramble_references)
    def self_scramble_references
        scramble = lambda do |name|
            return name if name.start_with?("__scrambled__")

            "__scrambled__" + name
        end

        key = @arguments[:subroutine_key]
        scrambled = scramble.call(key)

        @match = @match.sub(key, scrambled)
        @arguments[:subroutine_key] = scrambled
    end

    #
    # RecursivelyMatchPattern can cause its capture groups to be rematched
    #
    # @return [true] rematching is possible
    #
    def self_capture_group_rematch
        true
    end
end

class PatternBase
    #
    # Recursively match some outer pattern
    #
    # @param [String] reference a reference to an outer pattern
    #
    # @return [PatternBase] a PatternBase to append to
    #
    def recursivelyMatch(reference)
        insert(RecursivelyMatchPattern.new(reference))
    end
end

# (see PatternBase#recursivelyMatch)
def recursivelyMatch(reference)
    RecursivelyMatchPattern.new(reference)
end