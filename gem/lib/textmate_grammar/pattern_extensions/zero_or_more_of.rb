# frozen_string_literal: true

# An repeated pattern
# for some pattern `p` this is equivalent to (?:p*)
class ZeroOrMoreOfPattern < RepeatablePattern
    #
    # Construct a new ZeroOrMoreOfPattern
    #
    # @param [any] args arguments to pass to {PatternBase#initialize}
    # @api private
    #
    # @see zeroOrMoreOf
    # @see PatternBase#zeroOrMoreOf
    def initialize(*args)
        # run the normal pattern
        super(*args)
        # add quantifying options
        @at_least = 0
        @at_most = nil
    end

    # (see Pattern#quantifying_allowed?)
    # @return [false]
    def quantifying_allowed?
        false
    end

    # (see PatternBase#do_get_to_s_name)
    def do_get_to_s_name(top_level)
        top_level ? "zeroOrMoreOf(" : ".zeroOrMoreOf("
    end
end

class PatternBase
    #
    # Match pattern zero or more times
    #
    # @param [PatternBase,Regexp,String,Hash] pattern a pattern to match
    #
    # @return [PatternBase] a pattern to append to
    #
    def zeroOrMoreOf(pattern)
        insert(ZeroOrMoreOfPattern.new(pattern))
    end
end

# (see PatternBase#zeroOrMoreOf)
def zeroOrMoreOf(pattern)
    ZeroOrMoreOfPattern.new(pattern)
end