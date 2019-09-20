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

Grammar.register_transform(ResolvePlaceholders.new)