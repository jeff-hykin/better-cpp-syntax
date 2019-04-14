require 'json'
require 'yaml'

# TODO
    # use the turnOffNumberedCaptureGroups to disable manual regex groups (which otherwise would completely break the group attributes)
    # have grammar check at the end to make sure that all of the included repository_names are actually valid repo names
    # add method to append something to all tag names (add an extension: "blah" argument to "to_tag")
    # auto generate a repository entry when a pattern/range is used in more than one place
    # create a way to easily mutate anything on an existing pattern
    # add optimizations
        # add check for seeing if the last pattern was an OR with no attributes. if it was then change (a|(b|c)) to (a|b|c)
        # add a "is alreadly a group" flag to prevent double wrapping

class Grammar
    attr_accessor :data
    
    #
    # Globally accessible current grammar object
    #
    @@current_grammar = nil
    def self.current_grammar
        return @@current_grammar
    end
    
    #
    # Class Methods
    #
    def self.convertTagName(name, group_number, group_attributes, was_first_group_removed: nil)
        new_name = name
        # replace $match with its group number
        new_name.gsub!(/(?<=\$)match/,"#{group_number}" )
        # replace reference() with the group number it was referencing
        new_name.gsub! /(?<=\$)reference\((\w+)\)/ do |match|
            reference = match.match(/(?<=\()\w+/).to_s
            matching_index = group_attributes.find_index { |each| each[:reference] == reference }
            
            if matching_index == nil
                raise "\n\nWhen looking for #{match} I couldnt find any groups with that reference\nThe groups are:\n#{group_attributes.to_yaml}\n\n"
            elsif matching_index !=  group_attributes.size - 1 - group_attributes.reverse.find_index { |each| each[:reference] == reference }
                raise "\n\nWhen looking for #{match} I found multiple groups with that reference\nThe groups are:\n#{group_attributes.to_yaml}\n\n"
            end
            
            if was_first_group_removed
                matching_index -= 1
            end
            # the Nth matching_index is the (N+1)th capture group
            matching_index + 1
        end
        
        return new_name
    end
    # replaces [:backreference:reference] with the groups number it was referencing
    def self.fixupBackRefs(regex_as_string, group_attribute, was_first_group_removed: nil)
        references = Hash.new
        #convert all references to group numbers
        group_attribute.each.with_index { |each, index|
            if each[:reference]
                references[each[:reference]] = index - (was_first_group_removed ? 1 : 0) + 1
            end
        }
        # check for a backref to the Nth group, replace it with `\N` and try again
        regex_as_string.gsub! /\[:backreference:([^\\]+?):\]/ do |match|
            if references[$1] == nil
                raise "When processing the backReference:#{$1}, I couldn't find the group it was referencing"
            end
            # if the reference does exist, then replace it with it's number
            "\\#{references[$1]}"
        end
        return regex_as_string
    end
    
    
    def self.makeSureAGrammarExists
        if @@current_grammar == nil
            raise "\n\nHey, I think youre trying to use some of the Grammar tools (like Patterns) before you've defined a grammar\nAt the top of the program just do something like:\ngrammar = Grammar.new( name:'blah', scope_name: 'source.blah' )\nAfter that the other stuff should work\n\n"
        end
    end
    
    def self.toTag(data)
        # if its a string then include it directly
        if (data.instance_of? String)
            return { include: data }
        # if its a symbol then include a # to make it a repository_name reference
        elsif (data.instance_of? Symbol)
            return { include: "##{data}" }
        # if its a pattern, then convert it to a tag
        elsif (data.instance_of? Regexp) or (data.instance_of? Range)
            return data.to_tag
        # if its a hash, then just add it as-is
        elsif (data.instance_of? Hash)
            return data
        end
    end
    
    def self.convertRepository(repository)
        if (repository.is_a? Hash) && (repository != {})
            textmate_repository = {}
            for each_key, each_value in repository.each_pair
                textmate_repository[each_key.to_s] = Grammar.toTag(each_value)
            end
            return textmate_repository
        end
    end
    
    def self.convertIncludesToPatternList(includes)
        # Summary:
            # this takes a list, like:
            #     [
            #         # symbol thats the name of a repo
            #         :name_of_thing_in_repo,
            #         # and/or OOP grammar patterns
            #         newPattern(
            #             match: /thing/,
            #             tag_as: 'a.tag.name'
            #         ),
            #         # and/or ranges
            #         Range.new(
            #             start_pattern: /thing/,
            #             end_pattern: /endThing/,
            #             includes: [ :name_of_thing_in_repo ] # <- this list also uses this convertIncludesToPatternList() function
            #         ),
            #         # and/or hashes (hashes need to match the TextMate grammar JSON format)
            #         {
            #             match: /some_regex/,
            #             name: "some.tag.name"
            #         },
            #         # another example of the TextMate grammar format
            #         {
            #             include: '#name_of_thing_in_repo'
            #         }
            #     ]
            # then it converts that list into a TextMate grammar format like this:
            #     [
            #         # symbol conversion
            #         {
            #             include: '#name_of_thing_in_repo'
            #         },
            #         # pattern conversion
            #         {
            #             match: /thing/,
            #             name: 'a.tag.name'
            #         },
            #         # range conversion
            #         {
            #             begin: /thing/,
            #             end: /thing/,
            #             patterns: [
            #                 {
            #                     include: '#name_of_thing_in_repo'
            #                 }
            #             ]
            #         },
            #         # keeps TextMate hashes the same
            #         {
            #             match: /some_regex/,
            #             name: "some.tag.name"
            #         },
            #         # another example of the TextMate grammar format
            #         {
            #             include: '#name_of_thing_in_repo'
            #         }
            #     ]
        
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
            patterns.push(Grammar.toTag(each_include))
        end
        return patterns
    end
    
    #
    # Constructor
    #
    def initialize(name:nil, scope_name:nil, global_patterns:[], repository:{}, **other)
        @data = {
            name: name,
            scopeName: scope_name,
            **other,
            patterns: global_patterns,
            repository: repository,
        }
        @language_ending = scope_name.gsub /.+\.(.+)\z/, "\\1"
        @@current_grammar = self
    end
    
    #
    # Interal Helpers
    #
    def addLanguageEndings(data)
        if data.is_a? Array 
            for each in data
                addLanguageEndings(each)
            end
        elsif data.is_a? Hash
            for each in data
                key = each[0]
                value = each[1]
                
                if value == nil
                    next
                elsif value.is_a? Array
                    for each_sub_hash in value
                        addLanguageEndings(each_sub_hash)
                    end
                elsif value.is_a? Hash
                    addLanguageEndings(value)
                elsif key.to_s == "name"
                    new_names = []
                    for each in value.split(/\s/)
                        each_with_ending = each
                        # if it doesnt already have the ending then add it
                        if not (each_with_ending =~ /#{@language_ending}\z/)
                            each_with_ending += ".#{@language_ending}"
                        end
                        new_names << each_with_ending
                    end
                    data[key] = new_names.join(' ')
                end
            end
        end
    end
    
    #
    # External Helpers
    #
    def initalContextIncludes(*arguments)
        @data[:patterns] += Grammar.convertIncludesToPatternList(arguments)
    end
    
    def addToRepository(hash_of_repos)
        @data[:repository].merge!(hash_of_repos)
    end
    
    def to_h
        patterns = []
        for each in @data[:patterns]
            patterns.push(each.to_h)
        end
        output = {
            **@data,
            patterns: patterns,
        }
        addLanguageEndings(output[:repository])
        addLanguageEndings(output[:patterns])
        return output
    end
    
    def saveAsJsonTo(file_location)
        new_file = File.open(file_location+".json", "w")
        new_file.write(self.to_h.to_json)
        new_file.close
    end
    
    def saveAsYamlTo(file_location)
        new_file = File.open(file_location+".yaml", "w")
        new_file.write(self.to_h.to_yaml)
        new_file.close
    end
end

#
# extend Regexp to make expressions very readable
#
class Regexp
    attr_accessor :repository_name
    attr_accessor :has_top_level_group
    
    def self.runTest(test_name, arguments, lambda, new_regex)
        if arguments[test_name] != nil
            if not( arguments[test_name].is_a?(Array) )
                raise "\n\nI think there's a #{test_name}: argument, for a newPattern or helper, but the argument isn't an array (and it needs to be to work)\nThe other arguments are #{arguments.to_yaml}"
            end
            failures = []
            for each in arguments[test_name]
                if lambda[each]
                    failures.push(each)
                end
            end
            if failures.size > 0
                puts "\n\nWhen testing the pattern:\nregex: #{new_regex.inspect}\n with these arguments:\n#{arguments.to_yaml}\n\nThe #{test_name} test failed for:\n#{failures.to_yaml}"
            end
        end
    end
    
    #
    # English Helpers
    #
    def lookAheadFor      (other_regex) processRegexLookarounds(other_regex, 'lookAheadFor'     ) end
    def lookAheadToAvoid  (other_regex) processRegexLookarounds(other_regex, 'lookAheadToAvoid' ) end
    def lookBehindFor     (other_regex) processRegexLookarounds(other_regex, 'lookBehindFor'    ) end
    def lookBehindToAvoid (other_regex) processRegexLookarounds(other_regex, 'lookBehindToAvoid') end
    def then         (*arguments) processRegexOperator(arguments, 'then'         ) end
    def or           (*arguments) processRegexOperator(arguments, 'or'           ) end
    def maybe        (*arguments) processRegexOperator(arguments, 'maybe'        ) end
    def oneOrMoreOf  (*arguments) processRegexOperator(arguments, 'oneOrMoreOf'  ) end
    def zeroOrMoreOf (*arguments) processRegexOperator(arguments, 'zeroOrMoreOf' ) end
    def backReference(reference)
        #
        # generate the new regex
        #
        self_as_string = self.without_default_mode_modifiers
        other_regex_as_string = "[:backreference:#{reference}:]"
        new_regex = /#{self_as_string}#{other_regex_as_string}/
        
        #
        # carry over attributes
        #
        new_regex.group_attributes = self.group_attributes
        return new_regex
    end
    
    def to_tag(ignore_repository_entry: false, without_optimizations: false)
        if not ignore_repository_entry
            # if this pattern is in the repository, then just return a reference to the repository
            if self.repository_name != nil
                return { include: "##{self.repository_name}" }
            end
        end
        
        regex_as_string = self.without_default_mode_modifiers
        captures = self.captures
        output = {
            match: regex_as_string,
            captures: captures,
        }
        
        # if only a pattern list (no :match argument)
        if regex_as_string == '()'
            return {
                patterns: Grammar.convertIncludesToPatternList(@group_attributes[0][:includes])
            }
        end
        
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
        if self.has_top_level_group && !without_optimizations
            #
            # remove the group from the regex
            #
            # safety check (should always be false unless some other code is broken)
            if not ( (regex_as_string.size > 1) and (regex_as_string[0] == '(') and (regex_as_string[-1] == ')') )
                raise "\n\nInside Regexp.to_tag, trying to upgrade a group-1 into a tag name, there doesn't seem to be a group one even though there are attributes\nThis is a library-developer bug as this should never happen.\nThe regex is #{self}\nThe groups are#{self.group_attributes}"
            end
            # remove the first and last ()'s
            output[:match] = regex_as_string[1...-1]
            was_first_group_removed = true
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
            if zero_group.is_a?(Hash) && (zero_group[:name] != nil) && zero_group.keys.size == 1
                # remove the 0th capture group
                top_level_group = new_captures.delete('0')
                # add the name to the output
                output[:name] = Grammar.convertTagName(zero_group[:name], 0, @group_attributes, was_first_group_removed: was_first_group_removed)
            end
            output[:captures] = new_captures
        end

        # create real backreferences
        output[:match] = Grammar.fixupBackRefs(output[:match], @group_attributes, was_first_group_removed: was_first_group_removed)
        
        # convert all of the "$match" into their group numbers
        if output[:captures].is_a?(Hash)
            for each_group_number, each_group in output[:captures].each_pair
                if each_group[:name].is_a?(String)
                    output[:captures][each_group_number][:name] = Grammar.convertTagName(each_group[:name], each_group_number, @group_attributes, was_first_group_removed: was_first_group_removed)
                end
            end
        end
        
        # if captures dont exist then dont show them in the output
        if output[:captures] == {}
            output.delete(:captures)
        end
        
        return output
    end
    
    def captures
        captures = {}
        for group_number in 1..self.group_attributes.size
            raw_attributes = @group_attributes[group_number - 1]
            capture_group = {}
            
            # if no attributes then just skip
            if raw_attributes == {}
                next
            end
            
            # comments
            if raw_attributes[:comment] != nil
                capture_group[:comment] = raw_attributes[:comment]
            end
            
            # convert "tag_as" into the TextMate "name"
            if raw_attributes[:tag_as] != nil
                capture_group[:name] = raw_attributes[:tag_as]
            end
            
            # check for "includes" convert it to "patterns"
            if raw_attributes[:includes] != nil
                if not (raw_attributes[:includes].instance_of? Array)
                    raise "\n\nWhen converting a pattern into a tag (to_tag) there was a group that had an 'includes', but the includes wasn't an array\nThe pattern is:#{self}\nThe group attributes are: #{raw_attributes}"
                end
                # create the pattern list
                capture_group[:patterns] = Grammar.convertIncludesToPatternList(raw_attributes[:includes])
            end
            
            # check for "repository", run conversion on it
            if raw_attributes[:repository] != nil
                capture_group[:repository] = Grammar.convertRepository(raw_attributes[:repository])
            end
            
            # a check for :name, and :patterns and tell them to use tag_as and includes instead
            if raw_attributes[:name] or raw_attributes[:patterns]
                raise "\n\nSomewhere there is a name: or patterns: attribute being set (inside of a newPattern() or helper)\ninstead of name: please use tag_as:\ninstead of patterns: please use includes:\n\nThe arguments for the pattern are:\n#{raw_attributes.to_yaml}"
            end
            
            # check for unknown names
            attributes_copy = Marshal.load(Marshal.dump(raw_attributes))
            attributes_copy.delete(:name)
            attributes_copy.delete(:match)
            attributes_copy.delete(:patterns)
            attributes_copy.delete(:comment)
            attributes_copy.delete(:tag_as)
            attributes_copy.delete(:includes)
            attributes_copy.delete(:reference)
            attributes_copy.delete(:should_fully_match)
            attributes_copy.delete(:should_not_fully_match)
            attributes_copy.delete(:should_partial_match)
            attributes_copy.delete(:should_not_partial_match)
            attributes_copy.delete(:repository_name)
            attributes_copy.delete(:repository)
            if attributes_copy.size != 0
                raise "\n\nThere are arugments being given to a newPattern or a helper that are not understood\nThe unknown arguments are:\n#{attributes_copy}\n\nThe normal arguments are#{raw_attributes}"
            end
            
            # set the capture_group
            if capture_group != {}
                captures[group_number.to_s] = capture_group
            end
        end
        return captures
    end
    
    # convert it to a string and have it without the "(?-mix )" part
    def without_default_mode_modifiers()
        as_string = self.to_s
        # if it is the default settings (AKA -mix) then remove it
        if (as_string.size > 6) and (as_string[0..5] == '(?-mix')
            return self.inspect[1..-2]
        else 
            return as_string
        end
    end
    
    # replace all of the () groups with (?:) groups
    # has the side effect of removing all comments
    def without_numbered_capture_groups
        # unescaped ('s can exist in character classes, and character class-style code can exist inside comments.
        # this removes the comments, then finds the character classes: escapes the ('s inside the character classes then 
        # reverse the string so that varaible-length lookaheads can be used instead of fixed length lookbehinds
        as_string_reverse = self.to_s.reverse
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
    
    def processRegexOperator(arguments, operator)
        # first parse the arguments
        other_regex, attributes = Regexp.processGrammarArguments(arguments, operator)
        if other_regex == nil
            other_regex = //
        end
        
        no_attributes = attributes == {}
        
        #
        # Create the new regex
        #
        self_as_string = self.without_default_mode_modifiers
        other_regex_as_string = other_regex.without_default_mode_modifiers
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
                    # TODO eventually there should be a better optimization for this
                    new_regex = /(?:#{self_as_string}|#{other_regex_as_string})/
                end
            when 'maybe'
                # this one is more complicated because it contains an optimization
                # inefficient (but straightforward way): maybe(/a+/) == /(?:a+)?/
                # efficient (but more complicated way):  maybe(/a+/) == /a*/
                # (both forms are functionally equivlent)
                # the following code implements the more efficient way for single character matches
                is_an_escaped_character_with_one_or_more_quantifier = ((other_regex_as_string.size == 3) and (other_regex_as_string[0] == "\\") and (other_regex_as_string[-1] == "+"))
                is_a_normal_character_with_one_or_more_quantifier   = ((other_regex_as_string.size == 2) and (other_regex_as_string[0] != "\\") and (other_regex_as_string[-1] == "+"))
                if is_an_escaped_character_with_one_or_more_quantifier or is_a_normal_character_with_one_or_more_quantifier
                    # replace the last + with a *
                    optimized_regex_as_string = other_regex_as_string.gsub(/\+\z/, '*')
                    new_regex = /#{self_as_string}(#{optimized_regex_as_string})/
                    if no_attributes
                        new_regex = /#{self_as_string}#{optimized_regex_as_string}/
                    end
                else
                    new_regex = /#{self_as_string}(#{other_regex_as_string})?/
                    if no_attributes
                        new_regex = /#{self_as_string}(?:#{other_regex_as_string})?/
                    end
                end
            when 'oneOrMoreOf'
                new_regex = /#{self_as_string}((?:#{other_regex_as_string})+)/
                if no_attributes
                    new_regex = /#{self_as_string}(?:#{other_regex_as_string})+/
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
        # update the attributes of the new regex
        if no_attributes
            new_regex.group_attributes = self.group_attributes + other_regex.group_attributes
        else
            new_regex.group_attributes = self.group_attributes + [ attributes ] + other_regex.group_attributes
        end
        # if there are arributes, then those attributes are top-level
        if (self == //) and (attributes != {})
            new_regex.has_top_level_group = true
        end
        
        # if the pattern has a :repository_name
        if attributes[:repository_name] != nil
            new_regex.repository_name = attributes[:repository_name]
            Grammar.makeSureAGrammarExists
            Grammar.current_grammar.data[:repository][attributes[:repository_name]] = new_regex.to_tag(ignore_repository_entry:true)
        end
        
        #
        # run tests
        #
        replaced_backreferences = /#{new_regex.to_tag[:match]}/
        Regexp.runTest(:should_partial_match    , attributes, ->(each){       not (each =~ replaced_backreferences)       } , replaced_backreferences)
        Regexp.runTest(:should_not_partial_match, attributes, ->(each){      (each =~ replaced_backreferences) != nil     } , replaced_backreferences)
        Regexp.runTest(:should_fully_match      , attributes, ->(each){   not (each =~ /\A#{replaced_backreferences}\z/)  } , replaced_backreferences)
        Regexp.runTest(:should_not_fully_match  , attributes, ->(each){ (each =~ /\A#{replaced_backreferences}\z/) != nil } , replaced_backreferences)
        return new_regex
    end
    
    def processRegexLookarounds(other_regex, lookaround_name)
        #
        # generate the new regex
        #
        self_as_string = self.without_default_mode_modifiers
        other_regex_as_string = other_regex.without_default_mode_modifiers
        case lookaround_name
            when 'lookAheadFor'      then new_regex = /#{self_as_string}(?=#{ other_regex_as_string})/
            when 'lookAheadToAvoid'  then new_regex = /#{self_as_string}(?!#{ other_regex_as_string})/
            when 'lookBehindFor'     then new_regex = /#{self_as_string}(?<=#{other_regex_as_string})/
            when 'lookBehindToAvoid' then new_regex = /#{self_as_string}(?<!#{other_regex_as_string})/
        end
        
        #
        # carry over attributes
        #
        new_regex.group_attributes = self.group_attributes
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
            attributes = arg1.clone
            attributes.delete(:match)
        else
            raise "\n\nWhen creating a pattern, there is a #{error_location}() that was called, but the argument was not a Regex pattern or a Hash.\nThe function doesn't know what to do with the arguments:\n#{arguments}"
        end
        return [ other_regex, attributes ]
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
    # make the without_default_mode_modifiers do nothing for strings
    def without_default_mode_modifiers()
        return self
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
# Helper patterns
#
    def newPattern(*arguments)
        return //.then(*arguments)
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
    def backReference(reference)
        //.backReference(reference)
    end
#
# Range
#
class Range
    attr_accessor :as_tag, :repository_name
    
    def initialize(key_arguments)
        # parameters:
            # comment: (idk why youd ever use this, but it exists for backwards compatibility)
            # tag_as:
            # tag_content_as:
            # apply_end_pattern_last:
            # while:
            # start_pattern:
            # end_pattern:
            # includes:
            # repository:
            # repository_name:
        
        @as_tag = {}
        key_arguments = key_arguments.clone
        
        #
        # comment
        #
        comment = key_arguments[:comment]
        key_arguments.delete(:comment)
        if comment != nil && comment != ""
            @as_tag[:name] = comment
        end
        
        #
        # tag_as
        #
        tag_name = key_arguments[:tag_as]
        key_arguments.delete(:tag_as)
        if tag_name != nil && tag_name != ""
            @as_tag[:name] = tag_name
        end
        
        #
        # tag_content_as
        #
        tag_content_name = key_arguments[:tag_content_as]
        key_arguments.delete(:tag_content_as)
        if tag_content_name != nil && tag_content_name != ""
            @as_tag[:contentName] = tag_content_name
        end
        
        #
        # apply_end_pattern_last
        #
        apply_end_pattern_last = key_arguments[:apply_end_pattern_last]
        key_arguments.delete(:apply_end_pattern_last)
        if apply_end_pattern_last == 1 || apply_end_pattern_last == true
            @as_tag[:applyEndPatternLast] = apply_end_pattern_last
        end
        
        #
        # while
        #
        while_statement = key_arguments[:while]
        key_arguments.delete(:while)
        if while_statement != nil && while_statement != //
            @as_tag[:while] = while_statement
        end
        
        #
        # start_pattern
        #
        start_pattern = key_arguments[:start_pattern]
        if not ( (start_pattern.is_a? Regexp) and start_pattern != // )
            raise "The start pattern for a Range needs to be a non-empty regular expression\nThe Range causing the problem is:\n#{key_arguments}"
        end
        @as_tag[:begin] = start_pattern.without_default_mode_modifiers
        key_arguments.delete(:start_pattern)
        begin_captures = start_pattern.to_tag(without_optimizations: true)[:captures]
        if begin_captures != {} && begin_captures.to_s != "" 
            @as_tag[:beginCaptures] = begin_captures
        end
        
        #
        # end_pattern
        #
        end_pattern = key_arguments[:end_pattern]
        if not ( (end_pattern.is_a? Regexp) and end_pattern != // )
            raise "The end pattern for a Range needs to be a non-empty regular expression\nThe Range causing the problem is:\n#{key_arguments}"
        end
        @as_tag[:end] = end_pattern.without_default_mode_modifiers
        key_arguments.delete(:end_pattern)
        end_captures = end_pattern.to_tag(without_optimizations: true)[:captures]
        if end_captures != {} && end_captures.to_s != ""
            @as_tag[:endCaptures] = end_captures
        end
        
        #
        # includes
        #
        patterns = Grammar.convertIncludesToPatternList(key_arguments[:includes])
        key_arguments.delete(:includes)
        if patterns != []
            @as_tag[:patterns] = patterns
        end
        
        #
        # repository
        #
        repository = key_arguments[:repository]
        key_arguments.delete(:repository)
        if (repository.is_a? Hash) && (repository != {})
            @as_tag[:repository] = Grammar.convertRepository(repository)
        end
        
        #
        # repository_name
        #
        # extract the repository_name
        repository_name = key_arguments[:repository_name]
        key_arguments.delete(:repository_name)
        if repository_name.to_s != ""
            Grammar.makeSureAGrammarExists
            Grammar.current_grammar.data[:repository][repository_name] = self.to_tag
            # set the repository_name only after the repository entry is made
            @repository_name = repository_name
        end
        
        # TODO, add more error checking. key_arguments should be empty at this point
    end
    
    def to_tag
        if @repository_name != nil
            return {
                include: "##{@repository_name}"
            }
        end
        return as_tag
    end
end

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

class TokenHelper
    attr_accessor :tokens
    def initialize(tokens, for_each_token:nil)
        @tokens = tokens
        if for_each_token != nil
            for each in @tokens
                for_each_token[each]
            end
        end
    end
    
    
    def tokensThat(*adjectives)
        matches = @tokens.select do |each_token|
            output = true
            for each_adjective in adjectives
                # make sure to fail on negated symbols
                if each_adjective.is_a? NegatedSymbol
                    if each_token[each_adjective.to_sym] == true
                        output = false
                        break
                    end
                elsif each_token[each_adjective] != true
                    output = false
                    break
                end
            end
            output
        end
        return matches
    end
    
    def representationsThat(*adjectives)
        matches = self.tokensThat(*adjectives)
        return matches.map do |each| each[:representation] end
    end
    
    def that(*adjectives)
        matches = tokensThat(*adjectives)
        return /(?:#{matches.map {|each| Regexp.escape(each[:representation]) }.join("|")})/
    end
end
