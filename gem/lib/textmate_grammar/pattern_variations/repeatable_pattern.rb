# frozen_string_literal: true

require_relative "./base_pattern.rb"

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

    #
    # Does this pattern potentially rematch any capture groups
    #
    # @note this is used by FixRepeatedTagAs to modify patterns
    # The answer of true is a safe, but expensive to runtime, default
    #
    # @return [Boolean] True if this pattern potentially rematches capture groups
    #
    def self_capture_group_rematch
        # N or more
        return true if @at_most.nil? && !@at_least.nil?
        # up to N
        return true if !@at_most.nil? && @at_most > 1

        false
    end
end