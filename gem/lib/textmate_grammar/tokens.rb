require_relative "./pattern_variations/base_pattern"
require_relative "./pattern_extensions/placeholder"


# Take advantage of the placeholder system since this is just a dynamic form of a placeholder
class PatternCollector < PatternBase
end

class Grammar
    #
    # Aggregates certain patterns together based on their adjectives
    #
    # @param [String] selector A string using the selector syntax (explained below)
    #
    # @note The syntax for selection-building is simple.
    #  1. You can use adjectives such as :aClass or :aPrimitive
    #     anything matching /:[a-zA-Z0-9_]+/ is considered an "adjective"
    #  2. You can use three operators as follows  &&  ||  !
    #     they are the same as the ruby operators
    #  3. You can use paraentheses
    #  4. Whitespace, including newlines, are removed/ignored
    #     all other characters are invalid 
    #  _
    #  Here are some examples:
    #     ":aPrimitive"                             # finds any pattern with the :aPrimitive adjective
    #     ":aClass && :aPrimitive"                  # finds any pattern that is both :aClass and :aPrimitive
    #     ":aClass && !:aPrimitive"                 # finds any pattern whose adjectives include :aClass but don't include :aPrimitive
    #     ":aClass && !(:aPrimitive || aFunction)"  
    #     "!aFunction && :aValue"
    #
    # @return [PatternCollector]
    #
    def patternsThatAre(selector)
        # create the normal pattern that will act as a placeholder until the very end
        collector_pattern = PatternCollector.new({
            match: /(?#pattern_collector)/,
            pattern_filter: parseSelectorSyntax(selector),
        })
        # tell it what it needs to select-later
        return collector_pattern
    end
    
    #
    # convert a regex value into a proc filter used to select patterns
    #
    # @param [String] selector A string using the selector syntax (explained below)
    #
    # @note The syntax for selection-building is simple.
    #  1. You can use adjectives such as :aClass or :aPrimitive
    #     anything matching /:[a-zA-Z0-9_]+/ is considered an "adjective"
    #  2. You can use three operators as follows  &&  ||  !
    #     they are the same as the ruby operators
    #  3. You can use paraentheses
    #  4. Whitespace, including newlines, are removed/ignored
    #     all other characters are invalid 
    #  _
    #  Here are some examples:
    #     ":aPrimitive"                             # finds any pattern with the :aPrimitive adjective
    #     ":aClass && :aPrimitive"                  # finds any pattern that is both :aClass and :aPrimitive
    #     ":aClass && !:aPrimitive"                 # finds any pattern whose adjectives include :aClass but don't include :aPrimitive
    #     ":aClass && !(:aPrimitive || aFunction)"  
    #     "!aFunction && :aValue"
    #
    # @return [proc] a function that accepts a Pattern as input, and returns 
    #                a boolean of whether or not that pattern should 
    #                be included
    #

    def parseSelectorSyntax(selector)
        #
        # check input
        #
        case selector
        when Regexp
            # just remove the //'s from the string
            string_content = selector.inspect[1...-1]
        when String
            # do nothing (no special processing)
            string_content = selector
        else 
            raise <<~HEREDOC
                
                
                Trying to call parseSelectorSyntax() but the argument isn't a String or Regexp its #{selector.class}
                value: #{selector}
            HEREDOC
        end
        
        
        # remove all invalid characters, make sure length didn't change
        invalid_characters_removed = string_content.gsub(/[^a-zA-Z0-9_&|\(\)!: \n]/, "")
        if invalid_characters_removed.length != string_content.length
            raise <<~HEREDOC
                
                
                It appears the selector #{selector.inspect} contains some invalid characters
                with invalid characters: #{string_content.inspect}
                without invalid characters: #{invalid_characters_removed.inspect}
            HEREDOC
        end
        
        # find broken syntax
        if string_content =~ /[a-zA-Z0-9_]+\s+[a-zA-Z0-9_]+/ || string_content =~ /:[^a-zA-Z0-9_]/ || string_content =~ /[a-zA-Z0-9_]:/
            raise <<~HEREDOC
                
                Inside a selector: #{selector.inspect}
                this part of the syntax is invalid: #{$&.inspect}
                (theres a space between two adjectives)
                My guess is that it was half-edited
                or an accidental space was added
            HEREDOC
        end
        
        # convert all adjectives into inclusion checks
        string_content.gsub!(/\s+/," ")
        string_content.gsub!(/:[a-zA-Z0-9_]+/, 'pattern.arguments[:adjectives].include?(\0)')
        # convert it into a proc
        return ->(pattern) do
            eval(string_content) if pattern.is_a?(PatternBase) && pattern.arguments[:adjectives].is_a?(Array)
        end
    end
end