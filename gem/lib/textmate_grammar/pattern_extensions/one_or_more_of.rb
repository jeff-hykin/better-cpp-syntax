# frozen_string_literal: true

# An optional repeated pattern
# for some pattern `p` this is equivalent to (?:p+)
class OneOrMoreOfPattern < RepeatablePattern
    def initialize(*args)
        # run the normal pattern
        super(*args)
        # add quantifying options
        @at_least = 1
        @at_most = nil
    end

    # (see Pattern#quantifying_allowed?)
    # @return [false]
    def quantifying_allowed?
        false
    end

    # (see PatternBase#do_get_to_s_name)
    def do_get_to_s_name(top_level)
        top_level ? "oneOrMoreOf(" : ".oneOrMoreOf("
    end
end

class PatternBase
    #
    # Match pattern one or more times
    #
    # @param [PatternBase,Regexp,String,Hash] pattern a pattern to match
    #
    # @return [PatternBase] a pattern to append to
    #
    def oneOrMoreOf(pattern)
        insert(OneOrMoreOfPattern.new(pattern))
    end
end

# (see PatternBase#oneOrMoreOf)
def oneOrMoreOf(pattern)
    OneOrMoreOfPattern.new(pattern)
end