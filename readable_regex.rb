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

