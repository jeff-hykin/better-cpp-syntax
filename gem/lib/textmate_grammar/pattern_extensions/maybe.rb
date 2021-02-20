# frozen_string_literal: true

# An optional pattern
# for some pattern `p` this is equivalent to (?:p?)
class MaybePattern < RepeatablePattern
    #
    # Construct a new MaybePattern
    #
    # @param [any] args arguments to pass to {PatternBase#initialize}
    # @api private
    #
    # @see maybe
    # @see PatternBase#maybe
    def initialize(*args)
        # run the normal pattern
        super(*args)
        # add quantifying options
        @at_least = 0
        @at_most = 1
    end

    # (see Pattern#quantifying_allowed?)
    # @return [false]
    def quantifying_allowed?
        false
    end

    # (see PatternBase#do_get_to_s_name)
    def do_get_to_s_name(top_level)
        top_level ? "maybe(" : ".maybe("
    end
end

class PatternBase
    #
    # Optionally match pattern
    #
    # @param [PatternBase,Regexp,String,Hash] pattern a pattern to optionally match
    #
    # @return [PatternBase] a pattern to append to
    #
    def maybe(pattern)
        insert(MaybePattern.new(pattern))
    end
end

# (see PatternBase#maybe)
def maybe(pattern)
    MaybePattern.new(pattern)
end
