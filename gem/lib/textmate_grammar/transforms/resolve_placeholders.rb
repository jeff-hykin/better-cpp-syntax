# frozen_string_literal: true

#
# Resolves any embedded placeholders
#
class ResolvePlaceholders < GrammarTransform
    # (see ResolvePlaceholders)
    def pre_transform(pattern, options)
        return pattern unless pattern.is_a? PatternBase

        pattern.resolve(options[:repository])
    end
end

# resolving placeholders has no dependencies and makes analyzing patterns much nicer
# so it happens fairly early
Grammar.register_transform(ResolvePlaceholders.new, 0)