# frozen_string_literal: true

class StartMatchEmpty < GrammarLinter
    def pre_lint(key, pattern)
        return true unless pattern.is_a? PatternRange
        regexp = Regexp.new(pattern.start_pattern().evaluate().replace("\\G", '\uFFFF'))
        if "" =~ regexp and !(pattern.arguments[:zeroLengthStart?])
            puts "Warning: #{pattern.start_pattern().evaluate}\nmatches the zero length string (\"\").\n\n"
            puts "This means that the patternRange always matches"
            puts "You can disable this warning by settting :zeroLengthStart? to true."
            puts "The pattern is:\n#{pattern}"
        end
        true # return true for warnings
    end

    def self.options
        [:zeroLengthStart?]
    end

    def self.display_options(indent, options)
        ",\n#{indent}zeroLengthStart?: #{options[:zeroLengthStart?]}"
    end
end

Grammar.register_linter(StartMatchEmpty.new())