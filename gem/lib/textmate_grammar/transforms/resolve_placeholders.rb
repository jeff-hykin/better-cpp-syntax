# frozen_string_literal: true

#
# Resolves any embedded placeholders
#
class ResolvePlaceholders < GrammarTransform
    def pre_transform(pattern, options)
        return pattern unless pattern.is_a? PatternBase
        pattern_copy = pattern.__deep_clone__
        pattern_copy.map!(true) do |each_pattern_like|
            
            arguments = each_pattern_like.arguments
            repository = options[:repository]
            
            if each_pattern_like.is_a?(PlaceholderPattern)
                
                unless repository[arguments[:placeholder]].is_a? PatternBase
                    raise ":#{arguments[:placeholder]} is not a pattern and cannot be substituted"
                end

                each_pattern_like.arguments[:match] = repository[arguments[:placeholder]].__deep_clone__
            #
            # Collector pattern
            #
            elsif each_pattern_like.is_a?(PatternCollector)
                qualifying_patterns = []
                for each_key, each_value in repository
                    if arguments[:pattern_filter][each_value]
                        qualifying_patterns << each_value
                    end
                end
                if qualifying_patterns.size == 0
                    raise <<~HEREDOC
                        
                        
                        When creating a collector filter #{arguments[:pattern_filter]}
                        all the patterns that are in the grammar repository were searched
                        but none of thier adjective lists matched the collector filter
                    HEREDOC
                end
                
                
                # change this pattern right before the grammar is generated
                each_pattern_like.arguments[:match] = oneOf(qualifying_patterns)
            end
            each_pattern_like
        end
        pattern_copy.freeze
    end
end
                        
# resolving placeholders has no dependencies and makes analyzing patterns much nicer
# so it happens fairly early
Grammar.register_transform(ResolvePlaceholders.new, 0)