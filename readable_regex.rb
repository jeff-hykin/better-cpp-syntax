# extend Regexp to make expressions very readable
class Regexp
    # convert it to a string and have it without the "(?-mix )" part
    def as_readable_string()
        return self.to_s.sub(/\A\(\?\-mix\:/, "").sub(/\)\z/,"")
    end
    # an alias operator for "as_readable_string"
    def -@()
        return self.as_readable_string
    end
    # 
    # English Helpers
    # 
    def or(other_regex)
        return /(?:(?:#{self.as_readable_string}|#{other_regex.as_readable_string}))/
    end
    def and(other_regex)
        return /#{self.as_readable_string}#{other_regex.as_readable_string}/
    end
    def then(other_regex)
        return self.and(other_regex)
    end
    def lookAheadFor(other_regex)
        return /#{self.as_readable_string}(?=#{other_regex.as_readable_string})/
    end
    def lookAheadToAvoid(other_regex)
        return /#{self.as_readable_string}(?!#{other_regex.as_readable_string})/
    end
    def lookBehindFor(other_regex)
        return /#{self.as_readable_string}(?<=#{other_regex.as_readable_string})/
    end
    def lookBehindToAvoid(other_regex)
        return /#{self.as_readable_string}(?<!#{other_regex.as_readable_string})/
    end
    def thenNewGroup(name_or_regex, regex_pattern=nil)
        # numbered group
        if regex_pattern == nil
            return /#{self.as_readable_string}(#{name_or_regex.as_readable_string})/
        # named group
        else
            return /#{self.as_readable_string}(?<#{name_or_regex}>#{regex_pattern.as_readable_string})/
        end
    end
    def thenNewHiddenGroup(other_regex)
        return /#{self.as_readable_string}(?:#{other_regex.as_readable_string})/
    end
    def maybe(other_regex)
        regex_as_string = other_regex.as_readable_string
        # if its already a + character
        if (regex_as_string.size == 3) and regex_as_string[0] == "\\" and regex_as_string[-1] == "+"
            return /#{self.as_readable_string}#{regex_as_string[0] + regex_as_string[1]}*/
        elsif (regex_as_string.size == 2) and regex_as_string[0] != "\\" and regex_as_string[-1] == "+"
            return /#{self.as_readable_string}#{regex_as_string[0]}*/
        else
            return /#{self.as_readable_string}(?:#{regex_as_string})?/
        end
    end
    def oneOrMoreOf(other_regex)
        return /#{self.as_readable_string}(?:#{other_regex.as_readable_string})+/
    end
    def zeroOrMoreOf(other_regex)
        return /#{self.as_readable_string}(?:#{other_regex.as_readable_string})*/
    end
end

# 
# External helpers
#
    def lookAheadFor(regex_pattern)
        return //.lookAheadFor(regex_pattern)
    end
    def lookAheadToAvoid(regex_pattern)
        return //.lookAheadToAvoid(regex_pattern)
    end
    def lookBehindFor(regex_pattern)
        return //.lookBehindFor(regex_pattern)
    end
    def lookBehindToAvoid(regex_pattern)
        return //.lookBehindToAvoid(regex_pattern)
    end
    def newGroup(name_or_regex, regex_pattern=nil)
        return //.thenNewGroup(name_or_regex, regex_pattern)
    end
    def newHiddenGroup(regex_pattern)
        return //.thenNewHiddenGroup(regex_pattern)
    end
    def maybe(regex_pattern)
        return //.maybe(regex_pattern)
    end
    def oneOrMoreOf(other_regex)
        return //.oneOrMoreOf(other_regex)
    end
    def zeroOrMoreOf(other_regex)
        return //.zeroOrMoreOf(other_regex)
    end


# 
# Make safe failure for regex methods on strings
# 
class String 
    # make the as_readable_string do nothing for strings
    def as_readable_string()
        return self
    end
    # an alias operator for "as_readable_string"
    def -@()
        return self.as_readable_string
    end
end


# 
# Named patters
# 
@space = /\s/
@spaces = /\s+/
@digit = /\d/
@digits = /\d+/
@character = /\w/
@word = /\w+/
@word_boundary = /\b/
@white_space_boundary = /(?<=\s)(?=\S)/