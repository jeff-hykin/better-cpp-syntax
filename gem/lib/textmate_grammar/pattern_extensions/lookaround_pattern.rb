# frozen_string_literal: true

#
# Implements lookarounds
# for some pattern p this is equivalent to one of /(?=p)/, /(?!p)/, /(?<p)/, /(?<!p)/
# depending on the type
#
class LookAroundPattern < PatternBase
    # (see PatternBase#do_evaluate_self)
    def do_evaluate_self(groups)
        self_regex = @match
        self_regex = @match.evaluate(groups) if @match.is_a? PatternBase

        case @arguments[:type]
        when :lookAheadFor      then self_regex = "(?=#{self_regex})"
        when :lookAheadToAvoid  then self_regex = "(?!#{self_regex})"
        when :lookBehindFor     then self_regex = "(?<=#{self_regex})"
        when :lookBehindToAvoid then self_regex = "(?<!#{self_regex})"
        end

        if needs_to_capture?
            raise "You cannot capture a lookAround\nconsider capturing the pattern inside"
        end

        self_regex
    end

    # (see PatternBase#do_get_to_s_name)
    def do_get_to_s_name(top_level)
        top_level ? "lookAround(" : ".lookAround("
    end

    # (see PatternBase#do_add_attributes)
    def do_add_attributes(indent)
        ",\n#{indent}  type: :#{@arguments[:type]}"
    end

    # (see PatternBase#single_entity?)
    # @return [true]
    def single_entity?
        true
    end
end

class PatternBase
    #
    # Looks around for the pattern
    #
    # @param [Hash] pattern pattern constructor
    # option [Symbol] :type the look-around type
    #   can be one of :lookAheadFor, :lookAheadToAvoid, :lookBehindFor, :lookBehindToAvoid
    #
    # @return [PatternBase] a pattern to append to
    #
    def lookAround(pattern)
        insert(LookAroundPattern.new(pattern))
    end

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

# (see PatternBase#lookAround)
def lookAround(pattern)
    LookAroundPattern.new(pattern)
end

# TODO: eliminate this code duplication

# (see PatternBase#lookBehindToAvoid)
def lookBehindToAvoid(pattern)
    if pattern.is_a? Hash
        pattern[:type] = :lookBehindToAvoid
    else
        pattern = {match: pattern, type: :lookBehindToAvoid}
    end
    lookAround(pattern)
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

# (see PatternBase#lookAheadToAvoid)
def lookAheadToAvoid(pattern)
    if pattern.is_a? Hash
        pattern[:type] = :lookAheadToAvoid
    else
        pattern = {match: pattern, type: :lookAheadToAvoid}
    end
    lookAround(pattern)
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