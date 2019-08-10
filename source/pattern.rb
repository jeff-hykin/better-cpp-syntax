require 'deep_clone'

class String
    # a helper for writing multi-line strings for error messages 
    # example usage 
    #     puts <<-HEREDOC.remove_indent
    #     This command does such and such.
    #         this part is extra indented
    #     HEREDOC
    def remove_indent
        gsub(/^[ \t]{#{self.match(/^[ \t]*/)[0].length}}/, '')
    end
    def to_r_s
        return self
    end
end

class Regexp
    def is_single_entity?
        # a single character or single group would be considered a single entity
        # nil means unknown, and true means known to be true, and false means known to be false
        return nil
    end
    def to_r(groups = nil)
        return self
    end
    def to_r_s(groups = nil)
        return self.inspect[1..-2]
    end
    def integrate_regex(other_regex, groups)
        /#{other_regex.to_r_s}#{self.to_r_s}/
    end
end


class Pattern
    @match
    @type
    @arguments
    @next_pattern
    attr_accessor :next_pattern

    #
    # Helpers
    #

    # does @arguments contain any attributes that require this pattern be captured
    def needs_to_capture?
        capturing_attributes = [
            :tag_as,
            :reference,
            :includes,
            :repository,
        ]
        if @arguments == nil
            puts @match.class
        end
        not (@arguments.keys & capturing_attributes).empty?
    end

    def optimize_outer_group?
        needs_to_capture? and @next_pattern == nil
    end

    def insert!(pattern)
        last = self
        last = last.next_pattern while last.next_pattern
        last.next_pattern = pattern
        self
    end

    def insert(pattern)
        new_pattern = self.__deep_clone__()
        new_pattern.insert!(pattern)
    end
    
    def process_quantifiers_from_arguments
        # this sets the @at_most and @at_least value based on the arguments
        
        # 
        # Simplify the quantity down to just :at_least and :at_most
        # 
        attributes_clone = @arguments.clone
        # convert Enumerators to numbers
        for each in [:at_least, :at_most, :how_many_times?]
            if attributes_clone[each].is_a?(Enumerator)
                attributes_clone[each] = attributes_clone[each].size
            end
        end
        # extract the data
        at_least       = attributes_clone[:at_least]
        at_most        = attributes_clone[:at_most]
        how_many_times = attributes_clone[:how_many_times?]
        # simplify to at_least and at_most
        if how_many_times.is_a?(Integer)
            at_least = at_most = how_many_times
        end
        
        # check if quantifying is allowed
        # check after everything else encase additional quantifing options are created in the future
        if self.quantifing_allowed?
            @at_least = at_least
            @at_most = at_most
        else
            # if a quantifying value was set, raise an error telling the user that its not allowed
            if not ( at_most == nil && at_least == nil )
                raise <<-HEREDOC.remove_indent 
                    
                    Inside of the #{self.name} pattern, there are some quantity arguments like:
                        :at_least
                        :at_most
                        or :how_many_times?
                    These are not allowed in this kind of #{self.do_get_to_s_name}) pattern
                    If you did this intentionally please wrap it inside of a Pattern.new()
                    ex: #{self.do_get_to_s_name} Pattern.new( *your_arguments* ) )
                HEREDOC
            end
        end
    end
    
    # this is a simple_quantifier because it does not include atomic-ness
    def simple_quantifier
        # Generate the ending based on :at_least and :at_most
        
        # by default assume no quantifiers
        quantifier = ""
        # if there is no at_least, at_most, or how_many_times, then theres no quantifier
        if @at_least == nil and @at_most == nil
            quantifier = ""
        # if there is a quantifier
        else
            # if there's no at_least, then assume at_least = 1
            if @at_least == nil
                at_least = 1
            end
            # this is just a different way of "maybe"
            if @at_least == 0 and @at_most == 1
                quantifier = "?"
            # this is just a different way of "zeroOrMoreOf"
            elsif @at_least == 0 and @at_most == nil
                quantifier = "*"
            # this is just a different way of "oneOrMoreOf"
            elsif @at_least == 1 and @at_most == nil
                quantifier = "+"
            # if it is more complicated than that, just use a range
            else
                quantifier = "{#{@at_least},#{@at_most}}"
            end
        end
        return quantifier
    end
    
    # this method handles adding the at_most/at_least, dont_back_track methods
    # it returns regex-as-a-string
    def add_quantifier_options_to(match, groups)
        new_regex = match.to_r(groups).to_r_s
        quantifier = self.simple_quantifier
        # check if there are quantifiers
        if self.simple_quantifier() != ""
            # if the match is not a single entity, then it needs to be wrapped
            if not match.is_single_entity?
                new_regex = "(?:#{new_regex})"
            end
            # add the quantified ending
            new_regex += quantifier
        end
        # check if atomic
        if @arguments[:dont_back_track?] == true
            new_regex = "(?>#{new_regex})"
        end
        new_regex
    end
    
    def add_capture_group_if_needed(regex_as_string)
        if self.needs_to_capture?
            regex_as_string = "(#{regex_as_string})"
        end
        return regex_as_string
    end

    #
    # Public interface
    #

    def initialize(*arguments)
        @next_pattern = nil
        arg1 = arguments[0]
        # if only a pattern, set attributes to {}
        if arg1.is_a? Pattern or arg1.is_a? Regexp
            @match = arg1
            @arguments = {}
        # if its a Hash then extract the regex, and use the rest of the hash as the attributes
        elsif arg1.instance_of? Hash
            @match = arg1[:match]
            @arguments = arg1.clone
            @arguments.delete(:match)
            # extract the @at_least and @at_most values
            self.process_quantifiers_from_arguments()
        end
        # check for captures
        if @match.is_a? Regexp
            begin
                # this will throw a RegexpError if there are no capturing groups
                _ignore = /#{@match}\1/
                #at this point @match contains a capture group, complain
                raise <<-HEREDOC.remove_indent 
                    
                    There is a pattern that is being constructed from a regular expression
                    with a capturing group. This is not allowed, as the group cannot be tracked
                    The bad pattern is
                    #{self.to_s}
                HEREDOC
            rescue RegexpError
                # no cpature groups present, purposely do nothing
            end
        end
    end

    # attempts to provide a memorable name for a pattern
    def name
        if @arguments[:reference] != nil
            return @arguments[:reference]
        elsif @arguments[:tag_as] != nil
            return @arguments[:tag_as]
        end
        to_s
    end

    # converts a Pattern to a Hash represnting a textmate pattern
    def to_tag
        regex_as_string = self.to_r.to_r_s
        output = {
            match: regex_as_string,
        }
        if optimize_outer_group?
            # optimize captures by removing outermost
            output[:match] = output[:match][1..-2]
            output[:name] = @arguments[:tag_as]
        end

        output[:captures] = convert_group_attributes_to_captures(collect_group_attributes)
        output
    end

    # converts a pattern to a Regexp
    # if groups is nil consider this Pattern to be the top_level
    # when a pattern is top_level, group numbers and back references are relative to that pattern
    def to_r(groups = nil)
        top_level = groups == nil
        groups = collect_group_attributes if top_level
        
        # convert @match into a regex string
        self_regex = self.do_modify_regex(groups).to_r_s
        
        # allow the next_pattern to combine itself with this regex
        # (the default is just concatenation)
        if @next_pattern.respond_to?(:integrate_regex)
            self_regex = @next_pattern.integrate_regex(self_regex, groups).to_r_s
        end

        # tests are ran here
        # TODO: consider making tests their own method to prevent running them repeatedly

        if top_level
            return /#{fixupRegexReferences(groups, self_regex)}/
        end
        /#{self_regex}/
    end

    # Displays the Pattern as you would write it in code
    # This displays the canonical form, that is helpers such as oneOrMoreOf() become #then
    def to_s(depth = 0, top_level = true)
        regex_as_string = (@match.is_a? Pattern) ? @match.to_s(depth + 2, true) : @match.inspect
        regex_as_string = do_modify_regex_string(regex_as_string)
        indent = "  " * depth
        output = indent + do_get_to_s_name(top_level)
        output += "\n#{indent}  match: " + regex_as_string.lstrip
        output += ",\n#{indent}  tag_as: \"" + @arguments[:tag_as] + '"' if @arguments[:tag_as]
        output += ",\n#{indent}  reference: \"" + @arguments[:reference] + '"' if @arguments[:reference]
        output += do_add_attributes(indent)
        output += ",\n#{indent})"
        output += @next_pattern.to_s(depth, false).lstrip if @next_pattern
        return output
    end

    def start_pattern
        self
    end

    #
    # Chaining
    # 
    def then(pattern)
        pattern = Pattern.new(pattern) unless pattern.is_a? Pattern
        insert(pattern)
    end
    
    def maybe(pattern) insert(MaybePattern.new(pattern)) end
    def or(pattern) insert(OrPattern.new(pattern)) end
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

    def matchResultOf(reference) insert(BackReferencePattern.new(reference)) end
    def recursivelyMatch(reference) insert(SubroutinePattern.new(reference)) end
    #
    # Inheritance
    #
    
    # this method should return false for child classes
    # that manually set the quantity themselves: e.g. MaybePattern, OneOrMoreOfPattern, etc
    def quantifing_allowed?
        true
    end
    
    # what modifications to make to the @match
    # wrapping in a group is a common example
    # despite the name, this works on strings
    # called by #to_r
    def do_modify_regex(groups)
        self.add_capture_group_if_needed(self.add_quantifier_options_to(@match, groups))
    end
    
    # this pattern handles combining the previous pattern with the next pattern
    # in most situtaions, this just means concatenation
    def integrate_regex(previous_regex, groups)
        # by default just concat the groups
        /#{previous_regex.to_r_s}#{self.to_r(groups).to_r_s}/
    end

    # what modifications to make to @match.to_s
    # called by #to_s
    def do_modify_regex_string(self_regex)
        return self_regex
    end

    # return a string of any additional attributes that need to be added to the #to_s output
    # indent is a string with the amount of space the parent block is indented, attributes
    # are indented 2 more spaces
    # called by #to_s
    def do_add_attributes(indent)
        return ""
    end

    # What is the name of the method that the user would call
    # top_level is if a freestanding or chaining function is called
    # called by #to_s
    def do_get_to_s_name(top_level)
        top_level ? "Pattern.new(" : ".then("
    end

    # is the result of #to_r atomic for the purpose of regex building.
    # /(?:a|b)/ is atomic /(a)(b|c)/ is not. the safe answer is false.
    # NOTE: this is not the same concept as atomic groups, all groups are considered
    #   atomic for the purpose of regex building
    # called by #to_r
    def is_single_entity?
        nil
    end

    #
    # Internal
    #
    def collect_group_attributes(next_group = optimize_outer_group? ? 0 : 1)
        groups = []
        if needs_to_capture?
            groups << {group: next_group}.merge(@arguments)
            next_group += 1
        end
        if @match.is_a? Pattern
            new_groups = @match.collect_group_attributes(next_group)
            groups.concat(new_groups)
            next_group += new_groups.length
        end
        if @next_pattern.is_a? Pattern
            new_groups = @next_pattern.collect_group_attributes(next_group)
            groups.concat(new_groups)
            next_group += new_groups.length
        end
        groups
    end

    def fixupRegexReferences(groups, self_regex)
        references = Hash.new
        #convert all references to group numbers
        groups.each { |each|
            if each[:reference] != nil
                references[each[:reference]] = each[:group]
            end
        }
        self_regex.gsub!(/\[:backreference:([^\\]+?):\]/) do |match|
            if references[$1] == nil
                raise "\nWhen processing the matchResultOf:#{$1}, I couldn't find the group it was referencing"
            end
            # if the reference does exist, then replace it with it's number
            "\\#{references[$1]}"
        end
        # check for a subroutine to the Nth group, replace it with `\N` and try again
        self_regex.gsub!(/\[:subroutine:([^\\]+?):\]/) do |match|
            if references[$1] == nil
                raise "\nWhen processing the recursivelyMatch:#{$1}, I couldn't find the group it was referencing"
            else
                # if the reference does exist, then replace it with it's number
                "\\g<#{references[$1]}>"
            end
        end
        self_regex
    end

    def convert_group_attributes_to_captures(groups)
        captures = Hash.new()
        groups.each {|group|
            output = {}
            output[:name] = group[:tag_as]
            # process includes
            captures["#{group[:group]}"] = output
        }
        captures.reject {|capture| capture.empty?}
        # replace $match and $reference() with the appropriate capture number
        captures.each do |key, value|
            value[:name].gsub!(/\$(?:match|reference\((.+)\))/) do |match|
                next ("$" + key) if match == "$match"
                "$" + groups.detect{ |group| group[:reference] == $1}[:group].to_s
            end
        end
    end

    def __deep_clone__()
        options = @arguments.__deep_clone__()
        options[:match] = @match.__deep_clone__()
        new_pattern = self.class.new(options)
        new_pattern.insert!(@next_pattern.__deep_clone__())
    end
end

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

class OrPattern < Pattern
    def do_modify_regex(groups)
        # dont add the capture groups because they will be added on the outside of the integrate_regex
        self.add_capture_group_if_needed(self.add_quantifier_options_to(@match, groups))
    end
    def integrate_regex(previous_regex, groups)
        /(?:#{previous_regex.to_r_s}|#{self.to_r(groups).to_r_s})/
    end
    def do_get_to_s_name(top_level)
        top_level ? "or(" : ".or("
    end
    def is_single_entity?
        true
    end
end

class LookAroundPattern < Pattern
    def do_modify_regex(groups)
        self_regex = @match.to_r(groups).to_r_s
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

class SubroutinePattern < Pattern
    def initialize(reference)
        if reference.is_a? String
            super(
                match: Regexp.new("[:subroutine:#{reference}:]"),
                subroutine_key: reference
            )
        else
            # most likely __deep_clone__ was called, just call the super initalizer
            super(reference)
        end
    end
    def to_s(depth = 0, top_level = true)
        output = top_level ? "recursivelyMatch(" : ".recursivelyMatch("
        output += "\"#{@arguments[:subroutine_key]}\")"
        output += @next_pattern.to_s(depth, false).lstrip if @next_pattern
        return output
    end
    def atomic?
        true
    end
end

class BackReferencePattern < Pattern
    def initialize(reference)
        if reference.is_a? String
            super(
                match: Regexp.new("[:backreference:#{reference}:]"),
                backreference_key: reference
            )
        else
            # most likely __deep_clone__ was called, just call the super initalizer
            super(reference)
        end
    end
    def to_s(depth = 0, top_level = true)
        output = top_level ? "matchResultOf(" : ".matchResultOf("
        output += "\"#{@arguments[:backreference_key]}\")"
        output += @next_pattern.to_s(depth, false).lstrip if @next_pattern
        return output
    end
    def atomic?
        true
    end
end


class PatternRange < Pattern
    @start_pattern
    @end_pattern
    @while_pattern

    def initialize(arguments)
        if !arguments.is_a? Hash
            raise "PatternRange.new() expects a hash"
        end

        @start_pattern = arguments[:start_pattern]
        @end_pattern = arguments[:end_pattern]
        @while_pattern = arguments[:while_pattern]

        @start_pattern = Pattern.new(@start_pattern) if @start_pattern.is_a? Regexp
        @end_pattern = Pattern.new(@end_pattern) if @end_pattern.is_a? Regexp
        @while_pattern = Pattern.new(@while_pattern) if @while_pattern.is_a? Regexp

        arguments.delete(:start_pattern)
        arguments.delete(:end_pattern)
        arguments.delete(:while_pattern)

        super(arguments)
    end

    def start_pattern
        @start_pattern
    end

    def to_r
        raise "PatternRange cannot be used as a part of a Pattern"
    end

    def to_tag
        output = {
            begin: @start_pattern.to_r.to_r_s,
        }
        output[:end]   = @end_pattern.to_r.to_r_s   if @end_pattern   != nil
        output[:while] = @while_pattern.to_r.to_r_s if @while_pattern != nil
        output[:name]  = @arguments[:tag_as] if @arguments[:tag_as]   != nil
        output[:contentName] = @arguments[:tag_content_as] if @arguments[:tag_content_as] != nil

        output[:begin] = output[:begin][1..-2] if @start_pattern && @start_pattern.optimize_outer_group?
        output[:end]   = output[:end  ][1..-2] if @end_pattern   && @end_pattern.optimize_outer_group?
        output[:while] = output[:while][1..-2] if @while_pattern && @while_pattern.optimize_outer_group?

        output[:beginCaptures] = convert_group_attributes_to_captures(@start_pattern.collect_group_attributes)
        output[:endCaptures] = convert_group_attributes_to_captures(@start_pattern.collect_group_attributes)
        output[:whileCaptures] = convert_group_attributes_to_captures(@start_pattern.collect_group_attributes)

        output
    end

    def to_s
        start_pattern = (@start_pattern.is_a? Pattern) ? @start_pattern.to_s(2, true) : @start_pattern.inspect
        end_pattern = nil
        while_pattern = nil

        if @end_pattern != nil
            end_pattern = (@end_pattern.is_a? Pattern) ? @end_pattern.to_s(2, true) : @end_pattern.inspect
        end
        if @while_pattern != nil
            while_pattern = (@while_pattern.is_a? Pattern) ? @while_pattern.to_s(2, true) : @while_pattern.inspect
        end

        output = "PatternRange.new("
        output += "\n  start_pattern: " + start_pattern.lstrip
        output += ",\n  end_pattern: " + end_pattern.lstrip if end_pattern.is_a? String
        output += ",\n  while_pattern: " + while_pattern.lstrip if while_pattern.is_a? String
        output += ",\n)"
        
        output
    end
end
test_pat = Pattern.new(
    match: Pattern.new(/abc/).then(match: /aaa/, tag_as: "part1.part2.$reference(ghi)"),
    tag_as: "part1",
    reference: "abc",
).maybe(/def/).then(
    match: /ghi/,
    tag_as: "part2",
    reference: "ghi"
).lookAheadFor(/jkl/).matchResultOf("abc").recursivelyMatch("ghi").or(
    match: /optional/,
    tag_as: "variable.optional.$match"
)
puts test_pat.to_tag

test_range = PatternRange.new(
    start_pattern: /abc/,
    end_pattern: /def/,
)

puts test_range
puts test_range.to_tag