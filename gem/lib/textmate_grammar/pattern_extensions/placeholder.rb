# frozen_string_literal: true

#
# Implements using a pattern that has not been defined
#
class PlaceholderPattern < PatternBase
    #
    # Constructs a new placeholder pattern
    # @overload initialize(placeholder)
    #   @param [Symbol] placeholder the name to replace with
    #
    # @overload initialize(opts, deep_clone, original)
    #   @param (see PatternBase#initialize)
    #
    def initialize(placeholder, deep_clone = nil, original_arguments = nil)
        if deep_clone == :deep_clone
            super(placeholder, deep_clone, original_arguments)
        else
            super(
                match: Regexp.new("placeholder(?##{placeholder})"),
                placeholder: placeholder
            )
        end
    end

    # (see PatternBase#to_s)
    def to_s(depth = 0, top_level = true)
        return super unless @arguments[:match] == "placeholder"

        output = top_level ? "placeholder(" : ".placeholder("
        output += ":#{@arguments[:placeholder]})"
        output += @next_pattern.to_s(depth, false).lstrip if @next_pattern
        output
    end

    # (see PatternBase#to_tag)
    # @note this raises a runtime error if the pattern has not been resolved
    def to_tag
        if @arguments[:match].is_a?(String) && @arguments[:match].start_with?("placeholder")
            placeholder = @arguments[:placeholder]
            raise "Attempting to create a tag from an unresolved placeholder `:#{placeholder}'"
        end

        super()
    end

    # (see PatternBase#evaluate)
    # @note this raises a runtime error if the pattern has not been resolved
    def evaluate(groups = nil)
        if @arguments[:match].is_a?(String) && @arguments[:match].start_with?("placeholder")
            raise "Attempting to evaluate an unresolved placeholder `:#{@arguments[:placeholder]}'"
        end

        super(groups)
    end
end

class PatternBase
    #
    # Match a pattern that does not exist yet
    #
    # @param [Symbol] placeholder the name of the pattern to match
    #
    # @return [PatternBase] a pattern to append to
    #
    def placeholder(placeholder)
        insert(PlaceholderPattern.new(placeholder))
    end
end

# (see PatternBase#placeholder)
def placeholder(placeholder)
    PlaceholderPattern.new(placeholder)
end