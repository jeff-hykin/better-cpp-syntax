# frozen_string_literal: true

require_relative "./lookaround_pattern.rb"


class PatternBase
    #
    # Equivalent to lookAround with type set to :lookAheadFor
    #
    # @param (see lookAround)
    #
    # @return (see lookAround)
    #
    def lookAheadFor(pattern)
        if pattern.is_a? Hash
            pattern[:type] = :lookAheadFor
        else
            pattern = {match: pattern, type: :lookAheadFor}
        end
        lookAround(pattern)
    end
end

# (see PatternBase#lookAheadFor)
def lookAheadFor(pattern)
    if pattern.is_a? Hash
        pattern[:type] = :lookAheadFor
    else
        pattern = {match: pattern, type: :lookAheadFor}
    end
    lookAround(pattern)
end