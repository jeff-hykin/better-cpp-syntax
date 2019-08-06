def regex_to_s(regex)
    as_string = regex.to_s
    # if it is the default settings (AKA -mix) then remove it
    if (as_string.size > 6) and (as_string[0..5] == '(?-mix')
        return regex.inspect[1..-2]
    else 
        return as_string
    end
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

    def needs_to_capture
        capturing_attributes = [
            :tag_as,
            :reference,
            :includes,
            :repository,
        ]
        not (@arguments.keys & capturing_attributes).empty?
    end

    def insert(pattern)
        last = self
        last = last.next_regex while last.next_regex != nil
        last.next_regex = pattern
        self
    end

    #
    # Public interface
    #

    def initialize(*arguments)
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
                test_regex = /#{@regex}\1/
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

    def name
        if @arguments[:reference] != nil
            return @arguments[:reference]
        elsif @arguments[:tag_as] != nil
            return @arguments[:tag_as]
        end
        self.to_s
    end

    def to_tag
        regex_as_string = regex_to_s(self.to_r)
        output = {
            match: regex_as_string,
            captures: self.captures[1],
        }
        if needs_to_capture
            # optimize captures by removing outermost
            regex_as_string = regex_as_string[1..-2]
            output[:name] = @arguments[:tag_as]
        end
        # fixup matchResultOf and recursivelyMatch
        # for each of the keys in output[:captures] replace $match and $reference() with
        # the appropriate number
        output
    end

    def to_s(top_level = true)
        regex_as_string = do_modify_regex_string(((@regex.is_a? Pattern) ? @regex.to_s : @regex.inspect))
        output = do_get_to_s_name(top_level)
        output += "\n  match: " + regex_as_string
        output += ",\n  tag_as: " + @arguments[:tag_as] if @arguments[:tag_as] != nil
        output += ",\n  reference: " + @arguments[:reference] if @arguments[:reference] != nil
        output += do_add_attributes()
        output += ",\n)"
        output += @next_regex.to_s(false) if @next_regex != nil
        return output
    end

    def to_r
        self_regex = regex_to_s((@regex.is_a? Pattern) ? @regex.to_r : @regex)
        self_regex = do_modify_regex(self_regex)
        if next_regex == nil
            return /#{self_regex}/
        end
        /#{self_regex}(?:#{regex_to_s(next_regex.to_r)})/
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
    def maybe(pattern)
        insert(MaybePattern.new(pattern))
    end

    #
    # Inheritance
    #
    def do_modify_regex(self_regex)
        if needs_to_capture
            self_regex = "(#{self_regex})"
        end
        return self_regex
    end
    def do_modify_regex_string(self_regex)
        return self_regex
    end
    def do_add_attributes
        return ""
    end
    def do_get_to_s_name(top_level)
        top_level ? "Pattern.new(" : ".then("
    end

    #
    # Internal
    #
    def captures(capture_count = 0)
        captures = []
        if needs_to_capture
            captures << {capture: capture_count}.merge(generate_capture)
            capture_count += 1
        end
        if @regex.is_a? Pattern
            capture_count, new_captures = @regex.captures(capture_count) 
            captures.concat(new_captures)
        end
        if @next_regex != nil
            capture_count, new_captures = @next_regex.captures(capture_count) 
            captures.concat(new_captures)
        end
        return capture_count, captures
    end

    def generate_capture
        return {test: "bar"}
    end
end

class MaybePattern < Pattern
    def do_modify_regex(self_regex)
        if needs_to_capture
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

test = Pattern.new(
    match: /abc/,
    tag_as: "abc",
    reference: "abc"
).maybe(/def/).then(
    match: /ghi/,
    tag_as: "abc"
)

puts "regex:"
puts test.to_r.inspect
puts "\ntag:"
puts test.to_tag
puts "\nname:"
puts test.name
puts "\ncanonical form:"
puts test