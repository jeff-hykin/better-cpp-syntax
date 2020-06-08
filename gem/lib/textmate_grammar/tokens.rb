require_relative "./pattern_variations/base_pattern"
require_relative "./pattern_extensions/placeholder"


# Take advantage of the placeholder system since this is just a dynamic form of a placeholder
class TokenPattern < PatternBase
    def initialize(arg1,deep_clone=nil,arg3=nil)
        
        #
        # input checking
        #
        raise_input_error = ->() do
            raise <<~HEREDOC
                
                
                When creating a TokenPattern.new()
                The first argument was not in the form of { match: "your string", adjectives: [ :yourAdjective ]  }
                Instead the first argument was: #{arg1}
            HEREDOC
        end
        
        raise_input_error[] if not arg1.is_a?(Hash) 
        raise_input_error[] if not arg1[:match].is_a?(String) 
        raise_input_error[] if not arg1[:adjectives].is_a?(Array) 
        raise_input_error[] if not arg1[:adjectives].size > 0 && arg1[:adjectives].any?{|each| !each.is_a?(Symbol) }
        raise_input_error[] if not arg1[:bound].size > 0 && arg1[:adjectives].any?{|each| !each.is_a?(Symbol) }
        
        for each in arg1[:adjectives]
            if not (each.to_s =~ /[a-zA-Z0-9_]/)
                raise <<~HEREDOC
                    
                    
                    When creating a TokenPattern.new()
                    The set of adjectives is: #{arg1[:adjectives].inspect}
                    And this adjective: #{each.inspect}
                    uses something other than letters, numbers, and underscores
                    which sadly doesn't work with this system due to other constraints
                    
                    Please change it to only use letters numbers and underscores
                HEREDOC
            end
        end
        
        # just use the normal constructor after this check
        return super(arg1, deep_clone, arg3)
    end
end


# Take advantage of the placeholder system since this is just a dynamic form of a placeholder
class TokenCollectorPattern < PatternBase
end

class Grammar
    #
    # Aggregates certain tokens together using a syntax-in-string as a query
    #
    # @param [String] token_pattern A value that uses the tokenParsing syntax (explained below)
    #
    # @note The syntax for tokenParsing is simple, there are:
    #  - `adjectives` ex: isAClass
    #  - the `not` operator ex: !aFunc
    #  - the `or` operator ex: aClass || aPrimitive
    #  - the `and` operator ex: aClass && aPrimitive
    #  - paraentheses ex: (!aFunc) && aPrimitive
    #  _ 
    #  anything matching /[a-zA-Z0-9_]+/ is considered an "adjective"
    #  whitespace, including newlines, are removed/ignored
    #  all other characters are invalid
    #  _
    #  using only an adjective, ex: /isAClass/ means to only include
    #  Patterns that have that adjective in their adjective list
    #
    # @return [TokenCollectorPattern]
    #
    def tokensThatAre(token_pattern)
        # create the normal pattern that will act as a placeholder until the very end
        token_pattern = TokenCollectorPattern.new({
            match: /(?#token_collection)/,
            pattern_filter: parseTokenSyntax(token_pattern),
        })
        # tell it what it needs to select-later
        return token_pattern
    end
    
    #
    # convert a regex value into a proc filter used to select patterns
    #
    # @param [Regexp] token_pattern A value that uses the tokenParsing syntax (explained below)
    #
    # @note The syntax for tokenParsing is simple, there are:
    #  - `adjectives` ex: isAClass
    #  - the `not` operator ex: !aFunc
    #  - the `or` operator ex: :aClass || :aPrimitive
    #  - the `and` operator ex: :aClass && :aPrimitive
    #  - paraentheses ex: (!:aFunc) && :aPrimitive
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

    def parseTokenSyntax(token_pattern)
        #
        # check input
        #
        case token_pattern
        when Regexp
            # just remove the //'s from the string
            string_content = token_pattern.inspect[1...-1]
        when String
            # do nothing (no special processing)
        else 
            raise <<~HEREDOC
                
                
                Trying to call parseTokenSyntax() but the argument isn't a String or Regexp its #{token_pattern.class}
                value: #{token_pattern}
            HEREDOC
        end
        
        
        # remove all invalid characters, make sure length didn't change
        invalid_characters_removed = string_content.gsub(/[^a-zA-Z0-9_&|\(\)!: \n]/, "")
        if invalid_characters_removed.length != string_content.length
            raise <<~HEREDOC
                
                
                It appears the tokenSyntax #{token_pattern.inspect} contains some invalid characters
                with invalid characters: #{string_content.inspect}
                without invalid characters: #{invalid_characters_removed.inspect}
            HEREDOC
        end
        
        # find broken syntax
        if string_content =~ /[a-zA-Z0-9_]+\s+[a-zA-Z0-9_]+/ || string_content =~ /:[^a-zA-Z0-9_]/ || string_content =~ /[a-zA-Z0-9_]:/
            raise <<~HEREDOC
                
                Inside a tokenSyntax: #{token_pattern.inspect}
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