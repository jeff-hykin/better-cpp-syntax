require 'json'
require 'yaml'

# TODO
    # FIXME: need a way to set the top-level tag_as since I think overlapping groups don't get double tagged
        # have an 'has_top_level_group' that every pattern function sets to false, except for lookAhead/Behinds then have newPattern set it to true, then inside to_tag check that flag, if its true then remove the top level group from the regex
    # add support for a range (e.g. start: and end:)
    # add testing support
        # have a should_match: list, and a should_not_match: list
    # add the global register functionality
    # add support for tag_as to use $match, and then replace $match with the group number (e.g. $11)
    # add method to append something to all tag names (add an extension: "blah" argument to "to_tag")
    # create a way to easily mutate anything on an existing pattern
    # use the turnOffNumberedCaptureGroups to disable manual regex groups (which otherwise would completely break the group attributes)
    # add optimizations
        # dont call updateGroupAttributes and dont add a regex group if there are no attributes
        # add check for seeing if the last pattern was an OR with no attributes. if it was then change (a|(b|c)) to (a|b|c)
        # add a "is alreadly a group" flag to prevent double wrapping
    # FIXME, how to handle top-level 'includes' (will group 0 work for just patterns but not tags?)
    # TODO: add something (like 'tag_content_as') to support 'contentName' https://macromates.com/manual/en/language_grammars#language_rules


def turnOffNumberedCaptureGroups(regex)
    # unescaped ('s can exist in character classes, and character class-style code can exist inside comments.
    # this removes the comments, then finds the character classes: escapes the ('s inside the character classes then 
    # reverse the string so that varaible-length lookaheads can be used instead of fixed length lookbehinds
    as_string_reverse = regex.to_s.reverse
    no_preceding_escape = /(?=(?:(?:\\\\)*)(?:[^\\]|\z))/
    reverse_character_class_match = /(\]#{no_preceding_escape}[\s\S]*?\[#{no_preceding_escape})/
    reverse_comment_match = /(\)#{no_preceding_escape}[^\)]*#\?\(#{no_preceding_escape})/
    reverse_start_paraenthese_match = /\(#{no_preceding_escape}/
    reverse_capture_group_start_paraenthese_match = /(?<!\?)\(#{no_preceding_escape}/
    
    reversed_but_fixed = as_string_reverse.gsub(/#{reverse_character_class_match}|#{reverse_comment_match}/) do |match_data, more_data|
        # if found a comment, just remove it
        if (match_data.size > 3) and  match_data[-3..-1] == '#?('
            ''
        # if found a character class, then escape any ()'s that are in it
        else
            match_data.gsub reverse_start_paraenthese_match, '\\('.reverse
        end
    end
    # make all capture groups non-capture groups
    reversed_but_fixed.gsub! reverse_capture_group_start_paraenthese_match, '(?:'.reverse
    return Regexp.new(reversed_but_fixed.reverse)
end

def convertIncludesToPatternList(includes)
    # if input=nil then no patterns
    if includes == nil
        return []
    end
    # if input is not Array then error
    if not (includes.instance_of? Array)
        raise "\n\nWhen calling convertIncludesToPatternList() the argument wasn't an array\nThe argument is:#{includes}"
    end
    # create the pattern list
    patterns = []
    for each_include in includes
        # if its a string then include it directly
        if (each_include.instance_of? String)
            patterns.push({ include: each_include })
        # if its a symbol then include a # to make it a global_name reference
        elsif (each_include.instance_of? Symbol)
            patterns.push({ include: "##{each_include}" })
        # if its a pattern, then convert it to a tag
        elsif (each_include.instance_of? Regexp)
            patterns.push(each_include.to_tag)
        # if its a hash, then just add it as-is
        elsif (each_include.instance_of? Hash)
            patterns.push(each_include)
        end
    end
    return patterns
end

# extend Regexp to make expressions very readable
class Regexp
    attr_accessor :global_name
    attr_accessor :has_top_level_group
    
    #
    # English Helpers
    #
    def lookAheadFor      (other_regex) processRegexLookarounds(other_regex, 'lookAheadFor'     ) end
    def lookAheadToAvoid  (other_regex) processRegexLookarounds(other_regex, 'lookAheadToAvoid' ) end
    def lookBehindFor     (other_regex) processRegexLookarounds(other_regex, 'lookBehindFor'    ) end
    def lookBehindToAvoid (other_regex) processRegexLookarounds(other_regex, 'lookBehindToAvoid') end
    def then         (*arguments) processRegexOperator(arguments, 'then'        ) end
    def or           (*arguments) processRegexOperator(arguments, 'or'          ) end
    def maybe        (*arguments) processRegexOperator(arguments, 'maybe'       ) end
    def oneOrMoreOf  (*arguments) processRegexOperator(arguments, 'oneOrMoreOf' ) end
    def zeroOrMoreOf (*arguments) processRegexOperator(arguments, 'zeroOrMoreOf') end
    
    def to_tag
        # TODO, if this pattern has a :global_name then just return { include: #global_name }
        regex_as_string = self.removeDefaultModeModifiers
        captures = self.captures
        output = {
            match: regex_as_string,
            captures: captures
        }
        
        #
        # Top level pattern
        #
        # summary:
            # this if statement bascially converts this tag:
            # {
            #     match: '(oneThing)'
            #     captures: {
            #         '1' : {
            #             name: "thing.one"
            #         }
            #     }
            # }
            # into this tag:
            # {
            #     match: 'oneThing'
            #     name: "thing.one"
            # }
        if self.has_top_level_group
            #
            # remove the group from the regex
            #
            # safety check (should always be false unless some other code is broken)
            if not ( (regex_as_string.size > 1) and (regex_as_string[0] == '(') and (regex_as_string[-1] == ')') )
                raise "\n\nInside Regexp.to_tag, trying to upgrade a group-1 into a tag name, there doesn't seem to be a group one even though there are attributes\nThis is a library-developer bug as this should never happen.\nThe regex is #{self}\nThe groups are#{self.group_attributes}"
            end
            # remove the first and last ()'s
            output[:match] = regex_as_string[1...-1]
            
            #
            # update the capture groups
            #
            # decrement all of them by one (since the first one was removed)
            new_captures = {}
            for each_group_number, each_group in captures.each_pair
                decremented_by_1 = (each_group_number.to_i - 1).to_s
                new_captures[decremented_by_1] = each_group
            end
            zero_group = new_captures['0']
            # if name is the only value
            if (zero_group[:name] != nil) and zero_group.keys.size == 1
                # remove the 0th capture group
                top_level_group = new_captures.delete('0')
                # add the name to the output
                output[:name] = zero_group[:name]
            end
            # if all captures have been removed, then remove it from the output
            if new_captures == {}
                output.delete(:captures)
            else
                output[:captures] = new_captures
            end
        end
        
        return output
    end
    
    def captures
        captures = {}
        for group_number in 1..@group_attributes.size
            raw_attributes = @group_attributes[group_number - 1]
            
            # if no attributes then just skip
            if raw_attributes == {}
                next
            end
            
            # by default carry everything over
            captures[group_number.to_s] = raw_attributes
            # convert "tag_as" into the TextMate "name"
            if raw_attributes[:tag_as] != nil
                captures[group_number.to_s][:name] = raw_attributes[:tag_as]
                # remove it from the hash
                raw_attributes.delete(:tag_as)
            end
            
            # check for "includes"
            if raw_attributes[:includes] != nil
                if not (raw_attributes[:includes].instance_of? Array)
                    raise "\n\nWhen converting a pattern into a tag (to_tag) there was a group that had an 'includes', but the includes wasn't an array\nThe pattern is:#{self}\nThe group attributes are: #{raw_attributes}"
                end
                # create the pattern list
                captures[group_number.to_s][:patterns] = convertIncludesToPatternList(raw_attributes[:includes])
                # remove includes from the hash
                raw_attributes.delete(:includes)
            end
            # TODO add a check for :name, and :patterns and tell them to use tag_as and includes instead
            # add any other attributes
            captures[group_number.to_s].merge(raw_attributes)
        end
        return captures
    end
    
    # convert it to a string and have it without the "(?-mix )" part
    def removeDefaultModeModifiers()
        as_string = self.to_s
        # if it is the default settings (AKA -mix) then remove it
        if (as_string.size > 6) and (as_string[0..5] == '(?-mix')
            return as_string.sub(/\A\(\?\-mix\:/, "").sub(/\)\z/,"")
        else 
            return as_string
        end
    end
    
    # an alias operator for "removeDefaultModeModifiers"
    def -@()
        return self.removeDefaultModeModifiers
    end
    
    def processRegexOperator(arguments, operator)
        # first parse the arguments
        other_regex, attributes = Regexp.processGrammarArguments(arguments, operator)
        
        no_attributes = attributes == {}
        
        #
        # Create the new regex
        #
        self_as_string = self.removeDefaultModeModifiers
        other_regex_as_string = other_regex.removeDefaultModeModifiers
        case operator
            when 'then'
                new_regex = /#{self_as_string}(#{other_regex_as_string})/
                if no_attributes
                    new_regex = /#{self_as_string}#{other_regex_as_string}/
                end
            when 'or'
                new_regex = /(?:#{self_as_string}|(#{other_regex_as_string}))/
                if no_attributes
                    # the extra (?:(?:)) groups are because ruby will auto-optimize away the outer most one, even if only one is given
                    new_regex = /(?:(?:#{self_as_string}|#{other_regex_as_string}))/
                end
            when 'maybe'
                new_regex = /#{self_as_string}(#{other_regex_as_string})?/
                if no_attributes
                    new_regex = /#{self_as_string}(?:#{other_regex_as_string})?/
                end
                # this one is more complicated because it contains an optimization
                # inefficient (but straightforward way): maybe(/a+/) == /(?:a+)?/
                # efficient (but more complicated way):  maybe(/a+/) == /a*/
                # (both forms are functionally equivlent)
                # the following code implements the more efficient way for single character matches
                is_an_escaped_character_with_one_or_more_quantifier = (other_regex_as_string.size == 3) and other_regex_as_string[0] == "\\" and other_regex_as_string[-1] == "+"
                is_a_normal_character_with_one_or_more_quantifier   = (other_regex_as_string.size == 2) and other_regex_as_string[0] != "\\" and other_regex_as_string[-1] == "+"
                if is_an_escaped_character_with_one_or_more_quantifier or is_a_normal_character_with_one_or_more_quantifier
                    # replace the last + with a *
                    optimized_regex_as_string = other_regex_as_string.gsub(/\+\z/, '*')
                    new_regex = /#{self_as_string}(#{optimized_regex_as_string}*)/
                    if no_attributes
                        new_regex = /#{self_as_string}#{optimized_regex_as_string}*/
                    end
                end
            when 'oneOrMoreOf'
                new_regex = /#{self_as_string}((?:#{other_regex_as_string})+)/
                if no_attributes
                    new_regex = /#{self_as_string}((?:#{other_regex_as_string})+)/
                end
            when 'zeroOrMoreOf'
                new_regex = /#{self_as_string}((?:#{other_regex_as_string})*)/
                if no_attributes
                    new_regex = /#{self_as_string}(?:#{other_regex_as_string})*/
                end
        end
        
        #
        # Make changes to capture groups/attributes
        #
        # TODO, initialize global_name: whenever there is a global_name inside the attributes, add the pattern to the global grammar object
        # update the attributes of the new regex
        if no_attributes
            new_regex.group_attributes = self.group_attributes + other_regex.group_attributes
        else
            new_regex.group_attributes = self.group_attributes + [ attributes ] + other_regex.group_attributes
        end
        # if there has not been any consumption (only looking)
        # and if there are arributes, then those attributes are top-level
        if self.only_looking and attributes != {}
            new_regex.has_top_level_group = true
        end
        
        return new_regex
    end
    
    def processRegexLookarounds(other_regex, lookaround_name)
        #
        # generate the new regex
        #
        self_as_string = self.removeDefaultModeModifiers
        other_regex_as_string = other_regex.removeDefaultModeModifiers
        case lookaround_name
            when 'lookAheadFor'      then new_regex = /#{self_as_string}(?=#{ other_regex_as_string})/
            when 'lookAheadToAvoid'  then new_regex = /#{self_as_string}(?!#{ other_regex_as_string})/
            when 'lookBehindFor'     then new_regex = /#{self_as_string}(?<=#{other_regex_as_string})/
            when 'lookBehindToAvoid' then new_regex = /#{self_as_string}(?<!#{other_regex_as_string})/
        end
        
        #
        # carry over attributes
        #
        new_regex.only_looking = self.only_looking
        new_regex.has_top_level_group = self.has_top_level_group
        return new_regex
    end
    
    # summary
    #     the 'under the hood' of this feels complicated, but the resulting behavior is simple
    #     (this is abstracted into a class-method because its used in many instance functions)
    #     basically just let the user give either 1. only a pattern, or 2. let them give a Hash that provides more details
    def self.processGrammarArguments(arguments, error_location)
        arg1 = arguments[0]
        # if only a pattern, set attributes to {}
        if arg1.instance_of? Regexp
            other_regex = arg1
            attributes = {}
        # if its a Hash then extract the regex, and use the rest of the hash as the attributes
        elsif arg1.instance_of? Hash
            other_regex = arg1[:match]
            # make shallow copy
            attributes = arg1.to_hash
            attributes.delete(:match)
        else
            raise "\n\nWhen creating a pattern, there is a #{error_location}() that was called, but the argument was not a Regex pattern or a Hash.\nThe function doesn't know what to do with the arguments:\n#{arguments}"
        end
        return [ other_regex, attributes ]
    end
    
    #
    # getter/setter for only_looking
    #
        def only_looking=(value)
            @only_looking = value
        end
        
        def only_looking
            # if self is nothing
            if (self == //) or @only_looking
                return true
            else
                return false
            end
        end
    #
    # getter/setter for group_attributes
    #
        def group_attributes=(value)
            @group_attributes = value
        end
        
        def group_attributes
            if @group_attributes == nil
                @group_attributes = []
            end
            return @group_attributes
        end
end

# 
# Make safe failure for regex methods on strings
# 
class String
    # make the removeDefaultModeModifiers do nothing for strings
    def removeDefaultModeModifiers()
        return self
    end
    # an alias operator for "removeDefaultModeModifiers"
    def -@()
        return self.removeDefaultModeModifiers
    end
end


# 
# Named patterns
# 
@space = /\s/
@spaces = /\s+/
@digit = /\d/
@digits = /\d+/
@standard_character = /\w/
@word = /\w+/
@word_boundary = /\b/
@white_space_start_boundary = /(?<=\s)(?=\S)/
@white_space_end_boundary = /(?<=\S)(?=\s)/

#
# Helpers for Tokens
#
class NegatedSymbol
    def initialize(a_symbol)
        @symbol = a_symbol
    end
    def to_s
        return "not(#{@symbol.to_s})"
    end
    def to_sym
        return @symbol
    end
end

class Symbol
    def !@
        return NegatedSymbol.new(self)
    end
end

#
# Helper patterns
#
    def newPattern(*arguments)
        return //.then(*arguments)
    end
    def newRangeTag(key_arguments)
        start_as_tag = key_arguments[:start_pattern].to_tag
        end_as_tag = key_arguments[:end_pattern].to_tag
        # get start, end, handle their captures
        return {
            name: key_arguments[:tag_as],
            begin: start_as_tag[:match],
            beginCaptures: start_as_tag[:captures],
            end: end_as_tag[:match],
            endCaptures: end_as_tag[:captures],
            patterns: convertIncludesToPatternList(key_arguments[:includes])
        }
    end
    def lookAheadFor(*arguments)
        //.lookAheadFor(*arguments)
    end
    def lookAheadToAvoid(*arguments)
        //.lookAheadToAvoid(*arguments)
    end
    def lookBehindFor(*arguments)
        //.lookBehindFor(*arguments)
    end
    def lookBehindToAvoid(*arguments)
        //.lookBehindToAvoid(*arguments)
    end
    def maybe(*arguments)
        //.maybe(*arguments)
    end
    def oneOrMoreOf(*arguments)
        //.oneOrMoreOf(*arguments)
    end
    def zeroOrMoreOf(*arguments)
        //.zeroOrMoreOf(*arguments)
    end
