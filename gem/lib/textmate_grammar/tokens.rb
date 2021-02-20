require_relative "./pattern_variations/base_pattern"
require_relative "./pattern_extensions/placeholder"

# Take advantage of the placeholder system since this is just a dynamic form of a placeholder
class TokenPattern < PatternBase
end

class Grammar
    #
    # convert a regex value into a proc filter used to select patterns
    #
    # @param [Regexp] argument A value that uses the tokenParsing syntax (explained below)
    #
    # @note The syntax for tokenParsing is simple, there are:
    #  - `adjectives` ex: isAClass
    #  - the `not` operator ex: !isAClass
    #  - the `or` operator ex: isAClass || isAPrimitive
    #  - the `and` operator ex: isAClass && isAPrimitive
    #  - paraentheses ex: (!isAClass) && isAPrimitive
    #  _ 
    #  anything matching /[a-zA-Z0-9_]+/ is considered an "adjective"
    #  whitespace, including newlines, are removed/ignored
    #  all other characters are invalid
    #  _
    #  using only an adjective, ex: /isAClass/ means to only include
    #  Patterns that have that adjective in their adjective list
    #
    # @return [TokenPattern]
    #
    def tokenMatching(token_pattern)
        # create the normal pattern that will act as a placeholder until the very end
        token_pattern = TokenPattern.new({
            match: /(?#tokens)/,
            pattern_filter: parseTokenSyntax(token_pattern),
        })
        # tell it what it needs to select-later
        return token_pattern
    end
    
    #
    # convert a regex value into a proc filter used to select patterns
    #
    # @param [Regexp] argument A value that uses the tokenParsing syntax (explained below)
    #
    # @note The syntax for tokenParsing is simple, there are:
    #  - `adjectives` ex: isAClass
    #  - the `not` operator ex: !isAClass
    #  - the `or` operator ex: isAClass || isAPrimitive
    #  - the `and` operator ex: isAClass && isAPrimitive
    #  - paraentheses ex: (!isAClass) && isAPrimitive
    #  _ 
    #  anything matching /[a-zA-Z0-9_]+/ is considered an "adjective"
    #  whitespace, including newlines, are removed/ignored
    #  all other characters are invalid
    #  _
    #  using only an adjective, ex: /isAClass/ means to only include
    #  Patterns that have that adjective in their adjective list
    #
    # @return [proc] a function that accepts a Pattern as input, and returns 
    #                a boolean of whether or not that pattern should 
    #                be included
    #

    def parseTokenSyntax(argument)
        # validate input type
        if !argument.is_a?(Regexp)
            raise <<~HEREDOC
                
                
                Trying to call parseTokenSyntax() but the argument isn't Regexp its #{argument.class}
                value: #{argument}
            HEREDOC
        end
        # just remove the //'s from the string
        regex_content = argument.inspect[1...-1]
        
        # remove all invalid characters, make sure length didn't change
        invalid_characters_removed = regex_content.gsub(/[^a-zA-Z0-9_&|\(\)! \n]/, "")
        if invalid_characters_removed.length != regex_content.length
            raise <<~HEREDOC
                
                
                It appears the tokenSyntax #{argument.inspect} contains some invalid characters
                with invalid characters: #{regex_content.inspect}
                without invalid characters: #{invalid_characters_removed.inspect}
            HEREDOC
        end
        
        # find broken syntax
        if regex_content =~ /[a-zA-Z0-9_]+\s+[a-zA-Z0-9_]+/
            raise <<~HEREDOC
                
                Inside a tokenSyntax: #{argument.inspect}
                this part of the syntax is invalid: #{$&.inspect}
                (theres a space between two adjectives)
                My guess is that it was half-edited
                or an accidental space was added
            HEREDOC
        end
        
        # convert all adjectives into inclusion checks
        regex_content.gsub!(/\s+/," ")
        regex_content.gsub!(/[a-zA-Z0-9_]+/, 'pattern.arguments[:adjectives].include?(:\0)')
        # convert it into a proc
        return ->(pattern) do
            puts "regex_content is: #{regex_content} "
            eval(regex_content) if pattern.is_a?(PatternBase) && pattern.arguments[:adjectives].is_a?(Array)
        end
    end
end