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

                if options[:grammar].pattern_processing == repository[arguments[:placeholder]]
                    raise ":#{arguments[:placeholder]} is being processed and cannot be substituted"
                end

                each_pattern_like.arguments[:match] = repository[arguments[:placeholder]].__deep_clone__
            #
            # Collector pattern
            #
            elsif each_pattern_like.is_a?(PatternCollector)
                qualifying_patterns = []
                for each_key, each_value in repository
                    if arguments[:pattern_filter][each_value]
                        qualifying_patterns << each_value if arguments[:keywords_only]==false || each_value.arguments[:keyword] != nil
                    end
                end
                if qualifying_patterns.size == 0
                    # check and see if it was included in some pattern somewhere
                    bad_matches = []
                    for each in Grammar.all_patterns
                        if arguments[:pattern_filter][each]
                            bad_matches << each_value
                        end
                    end

                    raise <<~HEREDOC


                        When using the selector: #{arguments[:selector]}
                        After looking at all patterns stored in the grammar repository
                        (e.g. grammar[:something] = Pattern.new())
                        None of their adjective lists matched the collector filter
                        #{<<~HEREDOC if bad_matches.length > 0

                            It appears the selector DOES match some patterns
                            But those patterns are not in the grammar repo
                            If you want to match those patterns, add them to the grammar repo
                            ex:
                                grammar = Grammar.new()
                                grammar[:nameOfPattern] = ThatPattern
                        HEREDOC
                        }
                    HEREDOC
                end

                # lookAhead/behind optimization
                # if all of them are keyword patterns then extract out the keywords and only put lookAhead/lookBehinds at the ends
                if qualifying_patterns.all? { |each| each.arguments[:keyword] != nil }
                    keywords = qualifying_patterns.map{ |each| each.arguments[:keyword] }
                    # put longest words in the front to prevent match errors
                    keywords.sort_by!(&:length).reverse!
                    each_pattern_like.arguments[:match] = lookBehindToAvoid(/\w/).then(/(?:#{keywords.join("|")})/).lookAheadToAvoid(/\w/)
                # the normal/safe method
                else
                    # change the match pattern right before the grammar is generated
                    each_pattern_like.arguments[:match] = oneOf(qualifying_patterns)
                end
            end
            each_pattern_like
        end
        pattern_copy.freeze
    end
end

# resolving placeholders has no dependencies and makes analyzing patterns much nicer
# so it happens fairly early
Grammar.register_transform(ResolvePlaceholders.new, 0)