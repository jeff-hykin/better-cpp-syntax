# extend Regexp to make expressions very readable
class Regexp
    # convert it to a string and have it without the "(?-mix )" part
    def remove_default_mode_modifiers()
        as_string = self.to_s
        # if it is the default settings (AKA -mix) then remove it
        if (as_string.size > 6) and (as_string[0..5] == '(?-mix')
            return as_string.sub(/\A\(\?\-mix\:/, "").sub(/\)\z/,"")
        else 
            return as_string
        end
    end
    # an alias operator for "remove_default_mode_modifiers"
    def -@()
        return self.remove_default_mode_modifiers
    end
    # 
    # English Helpers
    # 
    def or(other_regex)
        return /(?:(?:#{self.remove_default_mode_modifiers}|#{other_regex.remove_default_mode_modifiers}))/
    end
    def and(other_regex)
        return /#{self.remove_default_mode_modifiers}#{other_regex.remove_default_mode_modifiers}/
    end
    def then(other_regex)
        return self.and(other_regex)
    end
    def lookAheadFor(other_regex)
        return /#{self.remove_default_mode_modifiers}(?=#{other_regex.remove_default_mode_modifiers})/
    end
    def lookAheadToAvoid(other_regex)
        return /#{self.remove_default_mode_modifiers}(?!#{other_regex.remove_default_mode_modifiers})/
    end
    def lookBehindFor(other_regex)
        return /#{self.remove_default_mode_modifiers}(?<=#{other_regex.remove_default_mode_modifiers})/
    end
    def lookBehindToAvoid(other_regex)
        return /#{self.remove_default_mode_modifiers}(?<!#{other_regex.remove_default_mode_modifiers})/
    end
    def thenNewGroup(name_or_regex, regex_pattern=nil)
        # numbered group
        if regex_pattern == nil
            return /#{self.remove_default_mode_modifiers}(#{name_or_regex.remove_default_mode_modifiers})/
        # named group
        else
            return /#{self.remove_default_mode_modifiers}(?<#{name_or_regex}>#{regex_pattern.remove_default_mode_modifiers})/
        end
    end
    def thenNewHiddenGroup(other_regex)
        return /#{self.remove_default_mode_modifiers}(?:#{other_regex.remove_default_mode_modifiers})/
    end
    def maybe(other_regex)
        regex_as_string = other_regex.remove_default_mode_modifiers
        # if its already a + character
        if (regex_as_string.size == 3) and regex_as_string[0] == "\\" and regex_as_string[-1] == "+"
            return /#{self.remove_default_mode_modifiers}#{regex_as_string[0] + regex_as_string[1]}*/
        elsif (regex_as_string.size == 2) and regex_as_string[0] != "\\" and regex_as_string[-1] == "+"
            return /#{self.remove_default_mode_modifiers}#{regex_as_string[0]}*/
        else
            return /#{self.remove_default_mode_modifiers}(?:#{regex_as_string})?/
        end
    end
    def oneOrMoreOf(other_regex)
        return /#{self.remove_default_mode_modifiers}(?:#{other_regex.remove_default_mode_modifiers})+/
    end
    def zeroOrMoreOf(other_regex)
        return /#{self.remove_default_mode_modifiers}(?:#{other_regex.remove_default_mode_modifiers})*/
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
    # make the remove_default_mode_modifiers do nothing for strings
    def remove_default_mode_modifiers()
        return self
    end
    # an alias operator for "remove_default_mode_modifiers"
    def -@()
        return self.remove_default_mode_modifiers
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
@white_space_start_boundary = /(?<=\s)(?=\S)/
@white_space_end_boundary = /(?<=\S)(?=\s)/