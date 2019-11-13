# frozen_string_literal: true

#
# RepeatablePattern provides quantifiers for patterns
#
class RepeatablePattern < PatternBase
    # @return [Integer,nil] the minimum amount that can be matched
    attr_accessor :at_least
    # @return [Integer,nil] the maximum amount that can be matched
    attr_accessor :at_most
    # (see PatternBase#initialize)
    def initialize(*arguments)
        super(*arguments)

        @at_least = nil
        @at_most = nil
        process_quantifiers_from_arguments
    end

    #
    # sets @at_least and @at_most based on arguments
    #
    # @return [void]
    #
    # @api private
    #
    def process_quantifiers_from_arguments
        # this sets the @at_most and @at_least value based on the arguments

        #
        # Simplify the quantity down to just :at_least and :at_most
        #
        attributes_clone = @arguments.clone
        # convert Enumerators to numbers
        [:at_least, :at_most, :how_many_times?].each do |each|
            if attributes_clone[each].is_a?(Enumerator)
                attributes_clone[each] = attributes_clone[each].size
            end
        end

        # canonize dont_back_track? and as_few_as_possible?
        @arguments[:dont_back_track?] ||= @arguments[:possessive?]
        @arguments[:as_few_as_possible?] ||= @arguments[:lazy?]
        if @arguments[:greedy?]
            @arguments[:dont_back_track?] = false
            @arguments[:as_few_as_possible?] = false
        end
        # extract the data
        at_least       = attributes_clone[:at_least]
        at_most        = attributes_clone[:at_most]
        how_many_times = attributes_clone[:how_many_times?]
        # simplify to at_least and at_most
        at_least = at_most = how_many_times if how_many_times.is_a?(Integer)

        # check if quantifying is allowed
        # check after everything else in case additional quantifying options
        # are created in the future
        if quantifying_allowed?
            @at_least = at_least
            @at_most = at_most
        # if a quantifying value was set and quantifying is not allowed, raise an error
        # telling the user that its not allowed
        elsif !(at_most.nil? && at_least.nil?)
            raise <<-HEREDOC.remove_indent

                Inside of the #{name} pattern, there are some quantity arguments like:
                    :at_least
                    :at_most
                    or :how_many_times?
                These are not allowed in this kind of #{do_get_to_s_name}) pattern
                If you did this intentionally please wrap it inside of a Pattern.new()
                ex: #{do_get_to_s_name} Pattern.new( *your_arguments* ) )
            HEREDOC
        end

        return unless @arguments[:dont_back_track?] && @arguments[:as_few_as_possible?]

        raise ":dont_back_track? and :as_few_as_possible? cannot both be provided"
    end

    #
    # converts @at_least and @at_most into the appropriate quantifier
    # this is a simple_quantifier because it does not include atomic-ness
    #
    # @return [String] the quantifier
    #
    def simple_quantifier
        # Generate the ending based on :at_least and :at_most

        # by default assume no quantifiers
        quantifier = ""
        # if there is no at_least, at_most, or how_many_times, then theres no quantifier
        if @at_least.nil? and @at_most.nil?
            quantifier = ""
        # if there is a quantifier
        else
            # if there's no at_least, then assume at_least = 1
            @at_least = 1 if @at_least.nil?

            quantifier =
                if @at_least == 1 and @at_most == 1
                    # no qualifier
                    ""
                elsif @at_least == 0 and @at_most == 1
                    # this is just a different way of "maybe"
                    "?"
                elsif @at_least == 0 and @at_most.nil?
                    # this is just a different way of "zeroOrMoreOf"
                    "*"
                elsif @at_least == 1 and @at_most.nil?
                    # this is just a different way of "oneOrMoreOf"
                    "+"
                elsif @at_least == @at_most
                    # exactly N times
                    "{#{@at_least}}"
                else
                    # if it is more complicated than that, just use a range
                    "{#{@at_least},#{@at_most}}"
                end
        end
        # quantifiers can be made possessive without requiring atomic groups
        quantifier += "+" if quantifier != "" && @arguments[:dont_back_track?] == true
        quantifier += "?" if quantifier != "" && @arguments[:as_few_as_possible?] == true
        quantifier
    end

    #
    # Adds quantifiers to match
    #
    # @param [String, PatternBase] match the pattern to add a quantifier to
    # @param [Array] groups group information, used for evaluating match
    #
    # @return [String] match with quantifiers applied
    #
    def add_quantifier_options_to(match, groups)
        match = match.evaluate(groups) if match.is_a? PatternBase
        quantifier = simple_quantifier
        # check if there are quantifiers
        if quantifier != ""
            # if the match is not a single entity, then it needs to be wrapped
            match = "(?:#{match})" unless string_single_entity?(match)
            # add the quantified ending
            match += quantifier
        elsif @arguments[:dont_back_track?] == true
            # make atomic, which allows arbitrary expression to be prevented from backtracking
            match = "(?>#{match})"
        end
        if @arguments[:word_cannot_be_any_of]
            word_pattern = @arguments[:word_cannot_be_any_of].map { |w| Regexp.escape w }.join "|"
            match = "(?!\\b(?:#{word_pattern})\\b)#{match}"
        end
        match
    end

    # (see PatternBase#do_evaluate_self)
    def do_evaluate_self(groups)
        add_capture_group_if_needed(add_quantifier_options_to(@match, groups))
    end

    # controls weather @arguments[:at_most] et. al. set @at_most et. al.
    # @note override when inheriting. Return false unless the subclass allow quantifying
    # @return [Boolean] if quantifying is allowed
    # @note the default implementation returns True
    def quantifying_allowed?
        true
    end

    #
    # (see PatternBase#do_add_attributes)
    #
    def do_add_attributes(indent)
        # rubocop:disable Metrics/LineLength
        output = ""
        # special #then arguments
        if quantifying_allowed?
            output += ",\n#{indent}  at_least: " + @arguments[:at_least].to_s if @arguments[:at_least]
            output += ",\n#{indent}  at_most: " + @arguments[:at_most].to_s if @arguments[:at_most]
            output += ",\n#{indent}  how_many_times: " + @arguments[:how_many_times].to_s if @arguments[:how_many_times]
            output += ",\n#{indent}  word_cannot_be_any_of: " + @arguments[:word_cannot_be_any_of].to_s if @arguments[:word_cannot_be_any_of]
        end
        output += ",\n#{indent}  dont_back_track?: " + @arguments[:dont_back_track?].to_s if @arguments[:dont_back_track?]
        output
        # rubocop:enable Metrics/LineLength
    end
end

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

#
# Pattern is a class alias for RepeatablePattern
#
Pattern = RepeatablePattern