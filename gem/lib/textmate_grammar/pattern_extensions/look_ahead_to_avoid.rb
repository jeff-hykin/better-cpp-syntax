# frozen_string_literal: true

require_relative "./lookaround_pattern.rb"

class PatternBase
    #
    # Equivalent to lookAround with type set to :lookAheadToAvoid
    #
    # @param (see lookAround)
    #
    # @return (see lookAround)
    #
    def lookAheadToAvoid(pattern)
        if pattern.is_a? Hash
            pattern[:type] = :lookAheadToAvoid
        else
            pattern = {match: pattern, type: :lookAheadToAvoid}
        end
        lookAround(pattern)
    end
end

# (see PatternBase#lookAheadToAvoid)
def lookAheadToAvoid(pattern)
    if pattern.is_a? Hash
        pattern[:type] = :lookAheadToAvoid
    else
        pattern = {match: pattern, type: :lookAheadToAvoid}
    end
    lookAround(pattern)
end