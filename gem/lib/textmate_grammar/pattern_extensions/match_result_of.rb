# frozen_string_literal: true

#
# Implements back references
# for some group N whose reference is "foo"
# matchResultOf("foo") results in the pattern /\N/
#
class MatchResultOfPattern < PatternBase
    def initialize(reference, deep_clone = nil, original_arguments = nil)
        if reference.is_a? String
            super(
                match: Regexp.new("(?#[:backreference:#{reference}:])"),
                backreference_key: reference
            )
        else
            # most likely __deep_clone__ was called, just call the super initializer
            super(reference, deep_clone, original_arguments)
        end
    end

    # (see PatternBase#to_s)
    def to_s(depth = 0, top_level = true)
        output = top_level ? "matchResultOf(" : ".matchResultOf("
        output += "\"#{@arguments[:backreference_key]}\")"
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
end

class PatternBase
    #
    # Match the result of some other pattern
    #
    # @param [String] reference a reference to match the result of
    #
    # @return [PatternBase] a pattern to append to
    #
    def matchResultOf(reference)
        insert(MatchResultOfPattern.new(reference))
    end
end

# (see PatternBase#matchResultOf)
def matchResultOf(reference)
    MatchResultOfPattern.new(reference)
end