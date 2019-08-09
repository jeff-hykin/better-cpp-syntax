require 'deep_clone'

def regex_to_s(regex)
    regex.inspect[1..-2]
end

class Pattern
    @regex
    @type
    @arguments
    @next_regex
    attr_accessor :next_regex

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
            puts @regex.class
        end
        not (@arguments.keys & capturing_attributes).empty?
    end

    def optimize_outer_group?
        needs_to_capture? and @next_regex == nil
    end

    def insert!(pattern)
        last = self
        last = last.next_regex while last.next_regex
        last.next_regex = pattern
        self
    end

    def insert(pattern)
        new_pattern = self.__deep_clone__()
        new_pattern.insert!(pattern)
    end

    #
    # Public interface
    #

    def initialize(*arguments)
        @next_regex = nil
        arg1 = arguments[0]
        # if only a pattern, set attributes to {}
        if arg1.is_a? Pattern or arg1.is_a? Regexp
            @regex = arg1
            @arguments = {}
        # if its a Hash then extract the regex, and use the rest of the hash as the attributes
        elsif arg1.instance_of? Hash
            @regex = arg1[:match]
            @arguments = arg1.clone
            @arguments.delete(:match)
        end
        # check for captures
        if @regex.is_a? Regexp
            begin
                # this will throw a RegexpError if there are no capturing groups
                _ignore = /#{@regex}\1/
                #at this point @regex contains a capture group, complain
                puts "There is a pattern that is being constructed from a regular expression"
                puts "with a capturing group. This is not allowed, as the group cannot be tracked"
                puts "The bad pattern is\n" + to_s
                raise "Error: see printout above"
            rescue RegexpError
                # no cpature groups present, purposely do nothing
            end
        end
    end

    # attempts to provide a memorable name for a pattern
    def name
        if @arguments[:reference]
            return @arguments[:reference]
        elsif @arguments[:tag_as]
            return @arguments[:tag_as]
        end
        to_s
    end

    # converts a Pattern to a Hash represnting a textmate pattern
    def to_tag
        regex_as_string = regex_to_s(self.to_r)
        output = {
            match: regex_as_string,
        }
        if optimize_outer_group?
            # optimize captures by removing outermost
            regex_as_string = regex_as_string[1..-2]
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

        self_regex = regex_to_s((@regex.is_a? Pattern) ? @regex.to_r(groups) : @regex)
        self_regex = do_modify_regex(self_regex)

        # tests are ran here
        # TODO: consider making tests their own method to prevent running them repeatedly
        if @next_regex
            if @next_regex.is_a? Pattern and @next_regex.atomic?
                self_regex += "#{regex_to_s(next_regex.to_r(groups))}"
            else
                self_regex += "(?:#{regex_to_s(next_regex.to_r(groups))})"
            end
        end

        if top_level
            return /#{fixupRegexReferences(groups, self_regex)}/
        end
        /#{self_regex}/
    end

    # Displays the Pattern as you would write it in code
    # This displays the canonical form, that is helpers such as oneOrMoreOf() become #then
    def to_s(depth = 0, top_level = true)
        regex_as_string = (@regex.is_a? Pattern) ? @regex.to_s(depth + 2, true) : @regex.inspect
        regex_as_string = do_modify_regex_string(regex_as_string)
        indent = "  " * depth
        output = indent + do_get_to_s_name(top_level)
        output += "\n#{indent}  match: " + regex_as_string.lstrip
        output += ",\n#{indent}  tag_as: " + @arguments[:tag_as] if @arguments[:tag_as]
        output += ",\n#{indent}  reference: " + @arguments[:reference] if @arguments[:reference]
        output += do_add_attributes(indent)
        output += ",\n#{indent})"
        output += @next_regex.to_s(depth, false).lstrip if @next_regex
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
    #
    # Inheritance
    #

    # what modifications to make to the @regex
    # wrapping in a group is a common example
    # despite the name, this works on strings
    # called by #to_r
    def do_modify_regex(self_regex)
        if needs_to_capture?
            self_regex = "(#{self_regex})"
        end
        return self_regex
    end

    # what modifications to make to @regex.to_s
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
    def atomic?
        return @regex.atomic? if @regex.is_a? Pattern
        false
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
        if @regex.is_a? Pattern
            new_groups = @regex.collect_group_attributes(next_group) 
            groups.concat(new_groups)
            next_group += new_groups.length
        end
        if @next_regex
            new_groups = @next_regex.collect_group_attributes(next_group) 
            next_group += new_groups.length
        end
        groups
    end

    def fixupRegexReferences(groups, self_regex)
        references = Hash.new
        #convert all references to group numbers
        groups.each { |each|
            if each[:reference]
                references[each[:reference]] = each[:group]
            end
        }
        self_regex.gsub!(/\[:backreference:([^\\]+?):\]/) do |match|
            if references[$1] == nil
                raise "When processing the matchResultOf:#{$1}, I couldn't find the group it was referencing"
            end
            # if the reference does exist, then replace it with it's number
            "\\#{references[$1]}"
        end
        # check for a subroutine to the Nth group, replace it with `\N` and try again
        self_regex.gsub!(/\[:subroutine:([^\\]+?):\]/) do |match|
            if references[$1] == nil
                raise "When processing the recursivelyMatch:#{$1}, I couldn't find the group it was referencing"
                # this is empty because the subroutine call is often built before the
                # thing it is referencing. 
                # ex:
                # newPattern(
                #     reference: "ref1",
                #     match: newPattern(
                #         /thing/.or(
                #             recursivelyMatch("ref1")
                #         )
                #     )
                # )
                # there's no way easy way to know if this is the case or not
                # so by default nothing is returned so that problems are not caused
                ""
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
    end

    def __deep_clone__()
        options = @arguments.__deep_clone__()
        options[:match] = @regex.__deep_clone__()
        new_pattern = self.class.new(options)
        new_pattern.insert!(@next_regex.__deep_clone__())
    end
end

class MaybePattern < Pattern
    def do_modify_regex(self_regex)
        if needs_to_capture?
            self_regex = "(#{self_regex})?"
        elsif
            self_regex = "(?:#{self_regex})?"
        end
        return self_regex
    end
    def do_get_to_s_name(top_level)
        top_level ? "maybe(" : ".maybe("
    end
end

class LookAroundPattern < Pattern
    def do_modify_regex(self_regex)
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

class BackReferencePattern < Pattern
    def initialize(reference)
        super(
            match: Regexp.new("[:backreference:#{reference}:]"),
            backreference_key: reference
        )
    end
    def to_s(depth = 0, top_level = true)
        output = top_level ? "matchResultOf(" : ".matchResultOf("
        output += "\"#{@arguments[:backreference_key]}\")"
        output += @next_regex.to_s(depth, false).lstrip if @next_regex
        return output
    end
    def atomic?
        true
    end
end

test = Pattern.new(
    match: Pattern.new(/abc/).then(match: /aaa/, tag_as: "aaa"),
    tag_as: "abc",
    reference: "abc"
).maybe(/def/).then(
    match: /ghi/,
    tag_as: "ghi"
).lookAheadFor(/jkl/).matchResultOf("abc")

test2 = test.then(/mno/)
puts test2

puts "regex:"
puts test.to_r.inspect
puts "\ntag:"
puts test.to_tag
puts "\nname:"
puts test.name
puts "\ncanonical form:"
puts test