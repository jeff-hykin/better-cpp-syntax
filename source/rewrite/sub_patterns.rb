require_relative 'pattern'

#
# Maybe
#

# An optional pattern
# for some pattern `p` this is equivlent to (?:p?)
class MaybePattern < Pattern
    def initialize(*args, **kwargs)
        # run the normal pattern
        super(*args, **kwargs)
        # add quantifing options
        @at_least = 0
        @at_most = 1
    end
    def quantifing_allowed?
        return false
    end
    def do_get_to_s_name(top_level)
        top_level ? "maybe(" : ".maybe("
    end
end

# returns a new MaybePattern
def maybe(pattern) MaybePattern.new(pattern) end

class Pattern
    #appends a new MaybePattern to the end of the pattern chain
    def maybe(pattern) insert(MaybePattern.new(pattern)) end
end

#
# Or
#

# Provides alternation
# Either the previous pattern or provided pattern is accepted
class OrPattern < Pattern
    def do_evaluate_self(groups)
        # dont add the capture groups because they will be added on the outside of the integrate_pattern
        self.add_capture_group_if_needed(self.add_quantifier_options_to(@match, groups))
    end
    def integrate_pattern(previous_regex, groups, is_single_entity)
        if is_single_entity
            return "(?:#{previous_regex}|#{self.evaluate(groups)})"
        end
        "(?:(?:#{previous_regex})|#{self.evaluate(groups)})"
    end
    def do_get_to_s_name(top_level)
        top_level ? "or(" : ".or("
    end
    def is_single_entity?
        true
    end
end

# no top level is provided

class Pattern
    #appends a new OrPattern to the end of the pattern chain
    def or(pattern) insert(OrPattern.new(pattern)) end
end

#
# OneOf
#

# Provides alternation
# when one of the passed in patterns is accepted, this pattern is accepted
class OneOfPattern < Pattern
    # create a new OneOfPattern
    # this is expects an array of patterns
    def initialize(patterns)
        if not patterns.is_a? Array
            puts <<-HEREDOC.remove_indent 
                oneOf() expects an array of patterns, the provided argument is not an array.
                The arguments to oneOf is below
                #{patterns}
            HEREDOC
        end
        # placeholder is here to avoid calling to_r in patterns prematurely
        @match = /placeholder regex/
        @arguments[:patterns] = patterns.map do |pattern|
            next pattern if pattern.is_a? Pattern
            Pattern.new(pattern)
        end
    end

    def do_evaluate_self(groups)
        patterns_strings = @arguments[:patterns].map do |pattern|
            regex = pattern.evaluate(groups)
            if regex.is_single_entity?
                next regex
            else
                next "(?:#{regex})"
            end
        end
        if needs_to_capture?
            return "(#{patterns_strings.join "|"})"
        else
            return "(?:#{patterns_strings.join "|"})"
        end
    end

    def is_single_entity?
        true
    end

    def to_s(depth = 0, top_level = true)
        indent = "  " * depth
        output = top_level ? "oneOf([" : ".oneOf(["
        output += "\n#{indent}  "
        output += (@arguments[:patterns].map do |pattern|
            pattern.to_s(depth + 1, true).lstrip
        end).join ",\n#{indent}  "
        output += "\n#{indent}])"
        output += @next_pattern.to_s(depth, false).lstrip if @next_pattern
        return output
    end
end

def oneOf(patterns) OneOfPattern.new(patterns) end

class Pattern
    #appends a new OneOfPattern to the end of the pattern chain
    def oneOf(pattern) insert(OneOfPattern.new(pattern)) end
end

#
# Lookarounds
#

class LookAroundPattern < Pattern
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
            raise "You can only capture a lookAround of type lookAheadFor" unless @arguments[:type] == :lookAheadFor
            self_regex = "(#{self_regex})"
        end
        return self_regex
    end
    def do_get_to_s_name(top_level)
        top_level ? "lookAround(" : ".lookAround("
    end
    def do_add_attributes(indent)
        ",\n#{indent}  type: :#{@arguments[:type]}"
    end
    def atomic?
        true
    end
end

def lookAround(pattern) LookAroundPattern.new(pattern) end
def lookBehindToAvoid(pattern)
    if pattern.is_a? Hash
        pattern[:type] = :lookBehindToAvoid
    elsif
        pattern = {match: pattern, type: :lookBehindToAvoid}
    end
    lookAround(pattern)
end
def lookBehindFor(pattern)
    if pattern.is_a? Hash
        pattern[:type] = :lookBehindFor
    elsif
        pattern = {match: pattern, type: :lookBehindFor}
    end
    lookAround(pattern)
end
def lookAheadToAvoid(pattern)
    if pattern.is_a? Hash
        pattern[:type] = :lookAheadToAvoid
    elsif
        pattern = {match: pattern, type: :lookAheadToAvoid}
    end
    lookAround(pattern)
end
def lookAheadFor(pattern)
    if pattern.is_a? Hash
        pattern[:type] = :lookAheadFor
    elsif
        pattern = {match: pattern, type: :lookAheadFor}
    end
    lookAround(pattern)
end

class Pattern
    def lookAround(pattern) insert(LookAroundPattern.new(pattern)) end

    def lookBehindToAvoid(pattern)
        if pattern.is_a? Hash
            pattern[:type] = :lookBehindToAvoid
        elsif
            pattern = {match: pattern, type: :lookBehindToAvoid}
        end
        lookAround(pattern)
    end
    def lookBehindFor(pattern)
        if pattern.is_a? Hash
            pattern[:type] = :lookBehindFor
        elsif
            pattern = {match: pattern, type: :lookBehindFor}
        end
        lookAround(pattern)
    end
    def lookAheadToAvoid(pattern)
        if pattern.is_a? Hash
            pattern[:type] = :lookAheadToAvoid
        elsif
            pattern = {match: pattern, type: :lookAheadToAvoid}
        end
        lookAround(pattern)
    end
    def lookAheadFor(pattern)
        if pattern.is_a? Hash
            pattern[:type] = :lookAheadFor
        elsif
            pattern = {match: pattern, type: :lookAheadFor}
        end
        lookAround(pattern)
    end
end

#
# matchResultOf
#

class BackReferencePattern < Pattern
    def initialize(reference, deep_clone = nil)
        if reference.is_a? String
            super(
                match: Regexp.new("[:backreference:#{reference}:]"),
                backreference_key: reference
            )
        else
            # most likely __deep_clone__ was called, just call the super initalizer
            super(reference, deep_clone)
        end
    end
    def to_s(depth = 0, top_level = true)
        output = top_level ? "matchResultOf(" : ".matchResultOf("
        output += "\"#{@arguments[:backreference_key]}\")"
        output += @next_pattern.to_s(depth, false).lstrip if @next_pattern
        return output
    end
    def is_single_entity?
        true
    end
end

def matchResultOf(reference) BackReferencePattern.new(reference) end

class Pattern
    def matchResultOf(reference) insert(BackReferencePattern.new(reference)) end
end

#
# recursivelyMatch
#

class SubroutinePattern < Pattern
    def initialize(reference, deep_clone = nil)
        if reference.is_a? String
            super(
                match: Regexp.new("[:subroutine:#{reference}:]"),
                subroutine_key: reference
            )
        else
            # most likely __deep_clone__ was called, just call the super initalizer
            super(reference, deep_clone)
        end
    end
    def to_s(depth = 0, top_level = true)
        output = top_level ? "recursivelyMatch(" : ".recursivelyMatch("
        output += "\"#{@arguments[:subroutine_key]}\")"
        output += @next_pattern.to_s(depth, false).lstrip if @next_pattern
        return output
    end
    def is_single_entity?
        true
    end
end

def recursivelyMatch(reference) SubroutinePattern.new(reference) end

class Pattern
    def recursivelyMatch(reference) insert(SubroutinePattern.new(reference)) end
end