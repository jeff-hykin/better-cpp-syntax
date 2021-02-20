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
            puts s.arguments[:tag_as] if s.arguments[:tag_as]
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

        name = pattern.name
        puts "The pattern `#{name}' has both an includes argument and a match argument that,"
        puts "it or a sub pattern has a tag_as argument."
        puts "this is not supported"

        true # TODO: fix issue
    end
end

Grammar.register_linter(IncludesThenTagAs.new)