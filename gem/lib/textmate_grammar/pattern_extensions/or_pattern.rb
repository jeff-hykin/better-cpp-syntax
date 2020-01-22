# frozen_string_literal: true

require_relative '../regex_operators/alternation'

# Provides alternation
# Either the previous pattern or provided pattern is accepted
# @note OneOfPattern is likely just as powerful and less confusing
class OrPattern < PatternBase
    #
    # (see PatternBase#evaluate_operator)
    #
    # @return [AlternationOperator] the alternation operator
    #
    def evaluate_operator
        AlternationOperator.new
    end

    #
    # Raises an error to prevent use as initial type
    #
    # @param _ignored ignored
    #
    # @return [void]
    #
    def evaluate(*_ignored)
        raise "evaluate is not implemented for OrPattern"
    end

    # (see PatternBase#do_get_to_s_name)
    def do_get_to_s_name(top_level)
        top_level ? "or(" : ".or("
    end

    # (see PatternBase#single_entity?)
    # @return [true]
    def single_entity?
        true
    end
end

class PatternBase
    #
    # Match either the preceding pattern chain or pattern
    #
    # @param [PatternBase,Regexp,String,Hash] pattern a pattern to match
    #   instead of the previous chain
    #
    # @return [PatternBase] a pattern to append to
    #
    def or(pattern)
        insert(OrPattern.new(pattern))
    end
end

# or does not have a top level option