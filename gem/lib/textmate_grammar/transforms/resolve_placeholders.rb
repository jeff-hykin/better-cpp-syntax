# frozen_string_literal: true

#
# Resolves any embedded placeholders
#
class ResolvePlaceholders < GrammarTransform
    def pre_transform(pattern, options)
        # skip past anything that isn't a pattern
        return pattern unless pattern.is_a? PatternBase
        
        pattern_copy = pattern.__deep_clone__
        # recursively fill in all of the placeholders by looking them up
        arguments = pattern.arguments
        repository = options[:repository]
        pattern_copy.recursively_transform do |each_pattern_like|
            #
            # placeholder pattern
            #
            if each_pattern_like.is_a?(PlaceholderPattern)
                name_of_placeholder = arguments[:placeholder]
                
                # error if can't find thing the placeholder is reffering to 
                if !repository[name_of_placeholder].is_a?(PatternBase)
                    raise "\n#{arguments[:placeholder]} is not a pattern and cannot be substituted"
                end
                
                # if the pattern exists though, make the substitution
                each_pattern_like.match = repository[arguments[:placeholder]].__deep_clone__
            
            #
            # token pattern
            #
            elsif each_pattern_like.is_a?(TokenPattern)
                qualifying_patterns = []
                for each_key, each_value in repository
                    next unless each_value.is_a?(PatternBase)
                    qualifying_patterns << each_value if arguments[:pattern_filter][each_value]
                end
                if qualifying_patterns.size == 0
                    raise <<-HEREDOC.remove_indent
                        
                        
                        When creating a token filter #{arguments[:pattern_filter]}
                        all the patterns that are in the grammar repository were searched
                        but none of thier adjective lists matched the token filter
                    HEREDOC
                end
                
                
                # change this pattern right before the grammar is generated
                each_pattern_like.match = oneOf(qualifying_patterns)
            end
            each_pattern_like
        end
        return pattern_copy
    end
end

# resolving placeholders has no dependencies and makes analyzing patterns much nicer
# so it happens fairly early
Grammar.register_transform(ResolvePlaceholders.new, 0)