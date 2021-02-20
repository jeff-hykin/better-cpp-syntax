# frozen_string_literal: true

require_relative "./lookaround_pattern.rb"

class PatternBase
    #
    # Equivalent to lookAround with type set to :lookBehindToAvoid
    #
    # @param (see lookAround)
    #
    # @return (see lookAround)
    #
    def lookBehindToAvoid(pattern)
        if pattern.is_a? Hash
            pattern[:type] = :lookBehindToAvoid
        else
            pattern = {match: pattern, type: :lookBehindToAvoid}
        end
        lookAround(pattern)
    end
end

# (see PatternBase#lookBehindToAvoid)
def lookBehindToAvoid(pattern)
    if pattern.is_a? Hash
        pattern[:type] = :lookBehindToAvoid
    else
        pattern = {match: pattern, type: :lookBehindToAvoid}
    end
    lookAround(pattern)
end