# frozen_string_literal: true

require 'textmate_grammar/util'

#
# Warns when a PatternRange has a start_pattern that matches the empty string
#
class StartMatchEmpty < GrammarLinter
    #
    # (see GrammarLinter#pre_lint)
    #
    def pre_lint(pattern, options)
        return true unless pattern.is_a? PatternRange

        regexp = with_no_warnings do
            Regexp.new(pattern.start_pattern.evaluate.gsub("\\G", '\uFFFF'))
        end
        if "" =~ regexp and !options[:zeroLengthStart?]
            puts "Warning: #{pattern.start_pattern.evaluate}"
            puts "matches the zero length string (\"\").\n\n"
            puts "This means that the patternRange always matches"
            puts "You can disable this warning by setting :zeroLengthStart? to true."
            puts "The pattern is:\n#{pattern}"
        end
        true # return true for warnings
    end

    #
    # Contributes the option :zeroLengthStart?
    #
    # :zeroLengthStart? disables this linter
    #
    # @return (see GrammarPlugin.options)
    #
    def self.options
        [:zeroLengthStart?]
    end

    #
    # Displays the state of the options
    #
    # @return (see GrammarPlugin.display_options)
    #
    def self.display_options(indent, options)
        ",\n#{indent}zeroLengthStart?: #{options[:zeroLengthStart?]}"
    end
end

Grammar.register_linter(StartMatchEmpty.new)