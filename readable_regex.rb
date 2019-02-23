require 'json'
require 'yaml'

# TODO
    # put these the class exentions (Regexp, String, etc) inside of the Module 

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
@standard_character = /\w/
@word = /\w+/
@word_boundary = /\b/
@white_space_start_boundary = /(?<=\s)(?=\S)/
@white_space_end_boundary = /(?<=\S)(?=\s)/

#
# Helpers
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


module GrammarHelper
    @@current_grammar = nil
    
    def makeSureGrammarExists()
        if @@current_grammar == nil
            raise "\n\nHey, I think youre trying to use the GrammarHelper before you've defined a grammar\nAt the top of the program just do something like:\ngrammar = GrammarHelper::Grammar.new( name:'blah', scope_name: 'source.blah' )\nAfter that the other stuff should work\n\n"
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
    
    def underscoresToDashes(tag_name)
        tag_name.to_s.gsub /_/, '-'
    end
    
    def tagNameToRepoName(tag_name)
        tag_name.to_s.gsub /\./, '-'
    end
    
    def isAGoodTagName(name)
        return ( (name != nil) and (name != "") and (name.to_i == 0))
    end

    class SimpleTag
        include GrammarHelper
        attr_accessor :tag_name, :patterns, :pattern, :groups, :tagger, :repo_name
        
        def initialize(tag_as:nil, pattern_sequence:nil, for_tagging:nil)
            makeSureGrammarExists()
            if tag_as == nil or pattern_sequence == nil
                raise "\n\nHey, I think there's a SimpleTag.new that doesn't have a tag_as: and/or pattern_sequence: argument.\n(Add those arguments to make this error go away)\n\n"
            end
            @pattern = //
            @groups = {}
            @tag_name = tag_as
            @repo_name = tagNameToRepoName(@tag_name)
            @patterns = pattern_sequence
            @tagger = for_tagging
            group_number = 0
            for each_pair in pattern_sequence
                group_number += 1
                group_name = each_pair[0]
                group_pattern = each_pair[1]
                default_tag = ""
                # if the group name is more than just a number, the use it as the default tag
                if isAGoodTagName(group_name.to_s)
                    default_tag = group_name.to_s
                end
                
                # remove all the capture groups from the pattern if its regex
                if group_pattern.is_a? Regexp
                    group_pattern = turnOffNumberedCaptureGroups(group_pattern)
                    if isAGoodTagName(default_tag)
                        default_tag = "#{@tag_name}.#{default_tag}"
                    end
                elsif (group_pattern.is_a? SimpleTag) or (group_pattern.is_a? TagRange)
                    new_tag_name = "#{group_pattern.tag_name}.#{@tag_name}"
                    if isAGoodTagName(group_pattern.tag_name) and isAGoodTagName(new_tag_name)
                        # add additional specificity of this parent tag name
                        default_tag = group_pattern.withTag(new_tag_name).to_h
                    else  
                        default_tag = group_pattern.to_h
                    end
                    # then switch the group pattern to be only the regex
                    group_pattern = turnOffNumberedCaptureGroups(group_pattern.pattern)
                end
                # add the pattern to the aggregate, and give it a capture group
                @pattern = /#{@pattern.remove_default_mode_modifiers}(#{group_pattern.remove_default_mode_modifiers})/
                @groups[group_name] = {
                    number: group_number,
                    pattern: group_pattern,
                    tag: default_tag,
                }
            end
            # run the tagger Process
            if for_tagging != nil
                for_tagging[@groups, self]
            end
        end
        
        def to_h
            captures = {}
            for each in @groups
                each_group_name = each[0]
                each_values = each[1]
                tag = each_values[:tag]
                # if the tag is not a good name, then ignore it 
                # (otherwise the tag will just be a number/nil/empty and there will be no way to not-name a group)
                if (tag.is_a? String) and not isAGoodTagName(tag)
                    next
                end
                # if its just a string then use it as the name of the tag
                if each_values[:tag].is_a? String
                    tag = {
                        name: underscoresToDashes(each_values[:tag])
                    }
                end
                # if it has more than just a name, then all of its data should be put inside a patterns list
                if each_values[:tag].is_a? Hash
                    if each_values[:tag].keys.size > 0
                        tag = {
                            patterns: [
                                each_values[:tag]
                            ]
                        }
                    end
                end
                # assign the correct name to the correct group number
                captures[each_values[:number].to_s] = tag
            end
            # use the "0" capture group tag in favor over the name key
            captures["0"] = { name: underscoresToDashes(@tag_name)}
            return {
                match: @pattern.remove_default_mode_modifiers,
                captures: captures
            }
        end
        
        def withTag(alternative_tag_name)
            return SimpleTag.new(tag_as: alternative_tag_name, pattern_sequence: @patterns, for_tagging: @tagger)
        end
    end
    
    class TagRange
        include GrammarHelper
        attr_accessor :tag_name, :start, :ending, :includes, :repo_name
        def initialize(tag_as:"", start_sequence:nil, for_start_tagging:nil, end_sequence:nil, for_end_tagging:nil, internal_patterns:[], is_copy:false)
            makeSureGrammarExists()
            if start_sequence == nil or end_sequence == nil
                raise "\n\nHey, inside of a TagRange.new there is missing either a start_sequence: or an end_sequence:  (both should be a Hash of TagRanges/SimpleTags)\nThose arguments needs to exist before the code will work\n\n"
            end
            if not(internal_patterns.is_a? Array)
                raise "\n\nHey, inside of a TagRange.new there is an internal_patterns: argument\nThat argument needs to be an array but right now its:\n#{internal_patterns}\n\n"
            end
            for each in internal_patterns
                # make sure the arguments are correct
                if not( (each.is_a? SimpleTag) or (each.is_a? TagRange) )
                    raise "\n\nHey, inside of a TagRange.new there is an internal_patterns: argument\nI is an array, but at least one of the arguments isnt a TagRange or SimpleTag\n(and it needs to be to work)\nThe value is: #{each}\n\n"
                end
            end
            # start part
            @tag_name = tag_as
            @repo_name = tagNameToRepoName(@tag_name)
            start_tag = ""
            if isAGoodTagName(@tag_name+".begin")
                start_tag = @tag_name+".begin"
            end
            @start = SimpleTag.new(tag_as:start_tag, pattern_sequence:start_sequence, for_tagging: for_start_tagging)
            end_tag = ""
            if isAGoodTagName(@tag_name+".end")
                end_tag = @tag_name+".end"
            end
            @ending = SimpleTag.new(tag_as:end_tag, pattern_sequence:end_sequence, for_tagging: for_end_tagging)
            @includes = internal_patterns
            # if it is a copy then the includes dont need to be added
            if not is_copy
                # add each of the includes to the current grammar repository
                for each in @includes
                    # until its in the repo and we found its name
                    while @@current_grammar[:repository][each.repo_name] != each.to_h
                        # if there is nothing there
                        if @@current_grammar[:repository][each.repo_name] == nil
                            # then add it
                            @@current_grammar[:repository][each.repo_name] = each.to_h
                        # increment the name if something else is already there
                        else
                            # replace ending number with higher number
                            each.repo_name.gsub!(/([\s\S])(?:(-)(\d+))?\z/) do |match|
                                "#{match[0]}-#{match[2..-1].to_i+1}"
                            end
                        end
                    end
                    # by the time it gets here the repo name will be valid
                    current_repo_entry = @@current_grammar[:repository][each]
                end
            end
        end
        
        def middle_pattern
            middle = //
            for each in @includes
                middle = /#{middle.remove_default_mode_modifiers}|#{each.remove_default_mode_modifiers}/
            end
            return middle
        end
        
        def pattern
            # add the [\s\S]* (AKA everything) to make sure that not everything in the middle MUST be matched by one of the includes
            # however when that is the case, note that the [\s\S]*? is non-greedy
            return /#{@start.pattern}(?:#{self.middle_pattern}|[\s\S]*?)#{@ending.pattern}/
        end

        def strict_pattern
            return /#{@start.pattern}(?:#{self.middle_pattern})#{@ending.pattern}/
        end
        
        def to_h
            patterns = []
            for each in @includes
                patterns.push({ include: "##{each.repo_name}" })
            end
            # add each of the includes to the current grammar repository
            return {
                name: underscoresToDashes(@tag_as),
                begin: @start.pattern,
                beginCaptures: @start.to_h[:captures],
                end: @ending.pattern,
                endCaptures: @ending.to_h[:captures],
                patterns: patterns,
            }
        end
        
        def withTag(tag_name)
            return TagRange.new(is_copy: true, tag_as:tag_name, start_sequence: @start.patterns, for_start_tagging: @start.tagger, end_sequence:@ending.patterns, for_end_tagging:@ending.tagger, internal_patterns:@includes)
        end
    end
    
    class Grammar
        include GrammarHelper
        attr_accessor :data
        def initialize(name:nil, scope_name:nil, global_patterns:[], repository:{}, **other)
            @data = {
                name: name,
                scopeName: scope_name,
                **other,
                patterns: global_patterns,
                repository: repository,
            }
            @language_ending = scope_name.gsub /.+\.(.+)\z/, "\\1"
            @@current_grammar = @data
        end
        
        def addLanguageEndings(data)
            if data.is_a? Array 
                for each in data
                    addLanguageEndings(each)
                end
            else
                for each in data
                    key = each[0]
                    value = each[1]
                    
                    if value.is_a? Array
                        for each_sub_hash in value
                            addLanguageEndings(each_sub_hash)
                        end
                    elsif value.is_a? Hash
                        addLanguageEndings(value)
                    elsif key.to_s == "name"
                        # if it doesnt already have the ending then add it
                        if not (value =~ /#{@language_ending}\z/)
                            value += ".#{@language_ending}"
                            data[key] = value
                        end
                    end
                end
            end
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
        
        def that(*adjectives)
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
            return /(?:(?:#{matches.map {|each| Regexp.escape(each[:representation]) }.join("|")}))/
        end
    end
end


# 
# Example usage:
# 
    # include GrammarHelper
    # grammar = Grammar.new(name:"cpp", scope_name: "source.cpp", version: 10)
    # var = SimpleTag.new tag_as: "variable", 
    #                     pattern_sequence: {
    #                         bound1: /\b/,
    #                         variable_name: /[a-zA-Z_][A-Za-z_0-9]*/, 
    #                         bound2: /\b/ 
    #                     },
    #                     for_tagging: ->(groups, this_pattern) do
    #                         groups[:variable_name][:tag] = "variable.name"
    #                     end

    # a = SimpleTag.new   tag_as: "scope-resolution",
    #                     pattern_sequence: {
    #                         source: var,
    #                         operator: /::/,
    #                         next_word: lookAheadFor(var.pattern),
    #                     }

    # string = TagRange.new   tag_as: "string",
    #                         start_sequence: {
    #                             double_quote: /"/ 
    #                         },
    #                         end_sequence: {
    #                             double_quote: /"/
    #                         },
    #                         internal_patterns: [var]

    # puts grammar.to_h.to_yaml