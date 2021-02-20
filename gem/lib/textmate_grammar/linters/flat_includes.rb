# frozen_string_literal: true

require 'textmate_grammar/util'

#
# Internal check, ensures that :includes is nil or a flat array
#
class FlatIncludes < GrammarLinter
    #
    # (see GrammarLinter#pre_lint)
    #
    def pre_lint(pattern, options)
        return true unless pattern.is_a? PatternBase
        return true if pattern.arguments[:includes].nil?

        if pattern.arguments[:includes].is_a?(Array) &&
           pattern.arguments[:includes].none? { |v| v.is_a? Array }
            flat = true
            pattern.arguments[:includes].map do |s|
                flat = false unless pre_lint(s, options)
            end
            return flat
        end

        puts "The pattern `#{pattern.name}' does not have a flat includes array."
        puts "This is an internal error"

        false
    end
end

Grammar.register_linter(FlatIncludes.new)