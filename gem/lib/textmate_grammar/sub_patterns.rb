# frozen_string_literal: true

require_relative 'pattern'

# An optional pattern
# for some pattern `p` this is equivalent to (?:p?)
class MaybePattern < Pattern
    #
    # Construct a new MaybePattern
    #
    # @param [any] args arguments to pass to {Pattern#initialize}
    # @api private
    #
    # @see maybe
    # @see Pattern#maybe
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

    # (see Pattern#do_get_to_s_name)
    def do_get_to_s_name(top_level)
        top_level ? "maybe(" : ".maybe("
    end
end

class Pattern
    #
    # Optionally match pattern
    #
    # @param [Pattern,Regexp,String] pattern a pattern to optionally match
    #
    # @return [Pattern] a pattern to append to
    #
    def maybe(pattern)
        insert(MaybePattern.new(pattern))
    end
end

# (see Pattern#maybe)
def maybe(pattern)
    MaybePattern.new(pattern)
end

# An repeated pattern
# for some pattern `p` this is equivalent to (?:p*)
class ZeroOrMoreOfPattern < Pattern
    #
    # Construct a new ZeroOrMoreOfPattern
    #
    # @param [any] args arguments to pass to {Pattern#initialize}
    # @api private
    #
    # @see zeroOrMoreOf
    # @see Pattern#zeroOrMoreOf
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

    # (see Pattern#do_get_to_s_name)
    def do_get_to_s_name(top_level)
        top_level ? "zeroOrMoreOf(" : ".zeroOrMoreOf("
    end
end

class Pattern
    #
    # Match pattern zero or more times
    #
    # @param [Pattern,Regexp,String] pattern a pattern to match
    #
    # @return [Pattern] a pattern to append to
    #
    def zeroOrMoreOf(pattern)
        insert(ZeroOrMoreOfPattern.new(pattern))
    end
end

# (see Pattern#zeroOrMoreOf)
def zeroOrMoreOf(pattern)
    ZeroOrMoreOfPattern.new(pattern)
end

# An optional repeated pattern
# for some pattern `p` this is equivalent to (?:p+)
class OneOrMoreOfPattern < Pattern
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

    # (see Pattern#do_get_to_s_name)
    def do_get_to_s_name(top_level)
        top_level ? "oneOrMoreOf(" : ".oneOrMoreOf("
    end
end

class Pattern
    #
    # Match pattern one or more times
    #
    # @param [Pattern,Regexp,String] pattern a pattern to match
    #
    # @return [Pattern] a pattern to append to
    #
    def oneOrMoreOf(pattern)
        insert(OneOrMoreOfPattern.new(pattern))
    end
end

# (see Pattern#oneOrMoreOf)
def oneOrMoreOf(pattern)
    OneOrMoreOfPattern.new(pattern)
end

# Provides alternation
# Either the previous pattern or provided pattern is accepted
# @note OneOfPattern is likely just as powerful and less confusing
class OrPattern < Pattern
    # (see Pattern#do_evaluate_self)
    def do_evaluate_self(groups)
        # don't add the capture groups because they will be added by integrate_pattern
        add_quantifier_options_to(@match, groups)
    end

    # (see Pattern#integrate_pattern)
    # @note this is overloaded to provide the alternation
    def integrate_pattern(previous_evaluate, groups, is_single_entity)
        return "(?:#{previous_evaluate}|#{evaluate(groups)})" if is_single_entity

        "(?:(?:#{previous_evaluate})|#{evaluate(groups)})"
    end

    # (see Pattern#do_get_to_s_name)
    def do_get_to_s_name(top_level)
        top_level ? "or(" : ".or("
    end

    # (see Pattern#single_entity?)
    # @return [true]
    def single_entity?
        true
    end
end

class Pattern
    #
    # Match either the preceding pattern chain or pattern
    #
    # @param [Pattern,Regexp,String] pattern a pattern to match instead of the previous chain
    #
    # @return [Pattern] a pattern to append to
    #
    def or(pattern)
        insert(OrPattern.new(pattern))
    end
end

# or does not have a top level option

# Provides alternation
# when one of the passed in patterns is accepted, this pattern is accepted
class OneOfPattern < Pattern
    # create a new OneOfPattern
    # this is expects an array of patterns

    #
    # Create a new OneOfPattern
    #
    # @param [Array<Pattern,Regexp,String>] patterns a list of patterns to match
    #
    def initialize(patterns, deep_clone = nil, original_arguments = nil)
        if deep_clone == :deep_clone
            super(patterns, deep_clone, original_arguments)
            return
        end
        unless patterns.is_a? Array
            puts <<-HEREDOC.remove_indent
                oneOf() expects an array of patterns, the provided argument is not an array.
                The arguments to oneOf is below
                #{patterns}
            HEREDOC
        end
        super(
            match: "one of",
            patterns: patterns.map do |pattern|
                next pattern if pattern.is_a? Pattern

                Pattern.new(pattern)
            end
        )
    end

    # (see Pattern#do_evaluate_self)
    def do_evaluate_self(groups)
        patterns_strings = @arguments[:patterns].map do |pattern|
            regex = pattern.evaluate(groups)
            next regex if pattern.single_entity?

            "(?:#{regex})"
        end

        return "(#{patterns_strings.join '|'})" if needs_to_capture?

        "(?:#{patterns_strings.join '|'})"
    end

    # (see Pattern#do_collect_self_groups)
    def do_collect_self_groups(next_group)
        groups = []
        @arguments[:patterns].each do |pattern|
            pat_groups = pattern.collect_group_attributes(next_group)
            groups.concat(pat_groups)
            next_group += pat_groups.length
        end
        groups
    end

    # (see Pattern#single_entity?)
    # @return [true]
    def single_entity?
        true
    end

    # (see Pattern#map!)
    def map!(&block)
        @arguments[:patterns].map! { |p| p.map!(&block) }
        @next_pattern.map!(&block) if @next_pattern.is_a? Pattern
        self
    end

    # (see Pattern#to_s)
    def to_s(depth = 0, top_level = true)
        indent = "  " * depth
        output = top_level ? "oneOf([" : ".oneOf(["
        output += "\n#{indent}  "
        output += (@arguments[:patterns].map do |pattern|
            pattern.to_s(depth + 1, true).lstrip
        end).join ",\n#{indent}  "
        output += "\n#{indent}])"
        output += @next_pattern.to_s(depth, false).lstrip if @next_pattern
        output
    end
end

class Pattern
    #
    # Match one of the supplied patterns
    #
    # @param [Array<Pattern,Regexp,String>] patterns a list of patterns to match
    #
    # @return [Pattern] a pattern to append to
    #
    def oneOf(patterns)
        insert(OneOfPattern.new(patterns))
    end
end

#
# (see Pattern#oneOf)
#
def oneOf(patterns)
    OneOfPattern.new(patterns)
end

#
# Implements lookarounds
# for some pattern p this is equivalent to one of /(?=p)/, /(?!p)/, /(?<p)/, /(?<!p)/
# depending on the type
#
class LookAroundPattern < Pattern
    # (see Pattern#do_evaluate_self)
    def do_evaluate_self(groups)
        self_regex = @match
        self_regex = @match.evaluate(groups) if @match.is_a? Pattern

        case @arguments[:type]
        when :lookAheadFor      then self_regex = "(?=#{self_regex})"
        when :lookAheadToAvoid  then self_regex = "(?!#{self_regex})"
        when :lookBehindFor     then self_regex = "(?<=#{self_regex})"
        when :lookBehindToAvoid then self_regex = "(?<!#{self_regex})"
        end

        if needs_to_capture?
            unless @arguments[:type] == :lookAheadFor
                raise "You can only capture a lookAround of type lookAheadFor"
            end

            self_regex = "(#{self_regex})"
        end

        self_regex
    end

    # (see Pattern#do_get_to_s_name)
    def do_get_to_s_name(top_level)
        top_level ? "lookAround(" : ".lookAround("
    end

    # (see Pattern#do_add_attributes)
    def do_add_attributes(indent)
        ",\n#{indent}  type: :#{@arguments[:type]}"
    end

    # (see Pattern#single_entity?)
    # @return [true]
    def single_entity?
        true
    end
end

class Pattern
    #
    # Looks around for the pattern
    #
    # @param [Hash] pattern pattern constructor
    # option [Symbol] :type the look-around type
    #   can be one of :lookAheadFor, :lookAheadToAvoid, :lookBehindFor, :lookBehindToAvoid
    #
    # @return [Pattern] a pattern to append to
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

# (see Pattern#lookAround)
def lookAround(pattern)
    LookAroundPattern.new(pattern)
end

# TODO: eliminate this code duplication

# (see Pattern#lookBehindToAvoid)
def lookBehindToAvoid(pattern)
    if pattern.is_a? Hash
        pattern[:type] = :lookBehindToAvoid
    else
        pattern = {match: pattern, type: :lookBehindToAvoid}
    end
    lookAround(pattern)
end

# (see Pattern#lookBehindFor)
def lookBehindFor(pattern)
    if pattern.is_a? Hash
        pattern[:type] = :lookBehindFor
    else
        pattern = {match: pattern, type: :lookBehindFor}
    end
    lookAround(pattern)
end

# (see Pattern#lookAheadToAvoid)
def lookAheadToAvoid(pattern)
    if pattern.is_a? Hash
        pattern[:type] = :lookAheadToAvoid
    else
        pattern = {match: pattern, type: :lookAheadToAvoid}
    end
    lookAround(pattern)
end

# (see Pattern#lookAheadFor)
def lookAheadFor(pattern)
    if pattern.is_a? Hash
        pattern[:type] = :lookAheadFor
    else
        pattern = {match: pattern, type: :lookAheadFor}
    end
    lookAround(pattern)
end

#
# Implements back references
# for some group N whose reference is "foo"
# matchResultOf("foo") results in the pattern /\N/
#
class BackReferencePattern < Pattern
    def initialize(reference, deep_clone = nil, original_arguments = nil)
        if reference.is_a? String
            super(
                match: Regexp.new("[:backreference:#{reference}:]"),
                backreference_key: reference
            )
        else
            # most likely __deep_clone__ was called, just call the super initializer
            super(reference, deep_clone, original_arguments)
        end
    end

    # (see Pattern#to_s)
    def to_s(depth = 0, top_level = true)
        output = top_level ? "matchResultOf(" : ".matchResultOf("
        output += "\"#{@arguments[:backreference_key]}\")"
        output += @next_pattern.to_s(depth, false).lstrip if @next_pattern
        output
    end

    # (see Pattern#single_entity?)
    # @return [true]
    def single_entity?
        true
    end
end

class Pattern
    #
    # Match the result of some other pattern
    #
    # @param [String] reference a reference to match the result of
    #
    # @return [Pattern] a pattern to append to
    #
    def matchResultOf(reference)
        insert(BackReferencePattern.new(reference))
    end
end

# (see Pattern#matchResultOf)
def matchResultOf(reference)
    BackReferencePattern.new(reference)
end

#
# Implements subexp calls
# for some group N whose reference is "foo"
# recursivelyMatch("foo") results in the pattern /\gN/
#
class SubroutinePattern < Pattern
    def initialize(reference, deep_clone = nil, original_arguments = nil)
        if reference.is_a? String
            super(
                match: Regexp.new("[:subroutine:#{reference}:]"),
                subroutine_key: reference
            )
        else
            # most likely __deep_clone__ was called, just call the super initializer
            super(reference, deep_clone, original_arguments)
        end
    end

    # (see Pattern#to_s)
    def to_s(depth = 0, top_level = true)
        output = top_level ? "recursivelyMatch(" : ".recursivelyMatch("
        output += "\"#{@arguments[:subroutine_key]}\")"
        output += @next_pattern.to_s(depth, false).lstrip if @next_pattern
        output
    end

    # (see Pattern#single_entity?)
    # @return [true]
    def single_entity?
        true
    end
end

class Pattern
    #
    # Recursively match some outer pattern
    #
    # @param [String] reference a reference to an outer pattern
    #
    # @return [Pattern] a Pattern to append to
    #
    def recursivelyMatch(reference)
        insert(SubroutinePattern.new(reference))
    end
end

# (see Pattern#recursivelyMatch)
def recursivelyMatch(reference)
    SubroutinePattern.new(reference)
end

#
# Implements using a pattern that has not been defined
#
class PlaceholderPattern < Pattern
    #
    # Constructs a new placeholder pattern
    # @overload initialize(placeholder)
    #   @param [Symbol] placeholder the name to replace with
    #
    # @overload initialize(opts, deep_clone, original)
    #   @param (see Pattern#initialize)
    #
    def initialize(placeholder, deep_clone = nil, original_arguments = nil)
        if deep_clone == :deep_clone
            super(placeholder, deep_clone, original_arguments)
        else
            super(
                match: "placeholder",
                placeholder: placeholder
            )
        end
    end

    # (see Pattern#to_s)
    def to_s(depth = 0, top_level = true)
        return super unless @match == "placeholder"
        output = top_level ? "placeholder(" : ".placeholder("
        output += ":#{@arguments[:placeholder]})"
        output += @next_pattern.to_s(depth, false).lstrip if @next_pattern
        output
    end

    def to_tag(*args)
        if @match == "placeholder"
            raise "Attempting to create a tag from an unresolved placeholder"
        end
        super(*args)
    end

    #
    # Resolves the placeholder
    #
    # @param [Hash] repository the repository to use to resolve the placeholder
    #
    # @return [self]
    #
    def resolve!(repository)
        unless repository[@arguments[:placeholder]].is_a? Pattern
            raise ":#{@arguments[:placeholder]} is not a Pattern and cannot be substituted"
        end

        @match = repository[@arguments[:placeholder]].__deep_clone__
        self
        # repository[@arguments[:placeholder]].resolve(repository)
    end
end

class Pattern
    #
    # Match a pattern that does not exist yet
    #
    # @param [Symbol] placeholder the name of the pattern to match
    #
    # @return [Pattern] a pattern to append to
    #
    def placeholder(placeholder)
        insert(PlaceholderPattern.new(placeholder))
    end

    #
    # Resolves any placeholder patterns
    #
    # @param [Hash] repository the repository to resolve patterns with
    #
    # @return [Pattern] a copy of self with placeholders resolved
    #
    def resolve(repository)
        __deep_clone__.map! { |s| s.resolve!(repository) if s.respond_to? :resolve! }.freeze
    end
end

# (see Pattern#placeholder)
def placeholder(placeholder)
    PlaceholderPattern.new(placeholder)
end