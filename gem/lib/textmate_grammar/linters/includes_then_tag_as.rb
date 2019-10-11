# frozen_string_literal: true

require 'textmate_grammar/util'

#
# A pattern that has an includes cannot have any tag_as in @match
#
class IncludesThenTagAs < GrammarLinter
    #
    # Does pattern or any of its children / siblings have a tag_as
    #
    # @param [PatternBase, String] pattern the pattern to check
    #
    # @return [Boolean] if any of the patterns have a tag_as
    #
    def tag_as?(pattern)
        return false unless pattern.is_a? PatternBase

        pattern.each do |s|
            return true if s.arguments[:tag_as]
        end

        false
    end

    #
    # (see GrammarLinter#pre_lint)
    #
    def pre_lint(pattern, options)
        return true unless pattern.is_a? PatternBase
        return true if pattern.is_a? PatternRange

        return false unless pre_lint(pattern.match, options)

        return true unless pattern.arguments[:includes].is_a? Array
        return true unless tag_as?(pattern.match)

        puts "The pattern `#{pattern.name}' has both an includes argument,"
        puts "and a match argument that, it or a sub pattern has a tag_as argument"
        puts "this is not supported"

        false
    end
end

Grammar.register_linter(IncludesThenTagAs.new)