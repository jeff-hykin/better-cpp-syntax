# frozen_string_literal: true

require_relative "./lookaround_pattern.rb"

class PatternBase
    #
    # Equivalent to lookAround with type set to :lookBehindFor
    #
    # @param (see lookAround)
    #
    # @return (see lookAround)
    #
    def lookBehindFor(pattern)
        if pattern.is_a? Hash
            pattern[:type] = :lookBehindFor
        else
            pattern = {match: pattern, type: :lookBehindFor}
        end
        lookAround(pattern)
    end
end

# (see PatternBase#lookBehindFor)
def lookBehindFor(pattern)
    if pattern.is_a? Hash
        pattern[:type] = :lookBehindFor
    else
        pattern = {match: pattern, type: :lookBehindFor}
    end
    lookAround(pattern)
end