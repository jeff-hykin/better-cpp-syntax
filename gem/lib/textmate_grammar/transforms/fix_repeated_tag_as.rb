# frozen_string_literal: true

#
# tag_as: inside a quantifier does not work as expected, this fixes it
#
class FixRepeatedTagAs < GrammarTransform
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
    # fixes tag_as when it is inside a quantifier
    # see https://github.com/jeff-hykin/cpp-textmate-grammar/issues/339#issuecomment-543285390
    # for an explanation of why and how
    #
    def pre_transform(pattern, options)
        return pattern.map { |v| pre_transform(v, options) } if pattern.is_a? Array
        return pattern unless pattern.is_a? PatternBase
        return pattern if pattern.is_a? PatternRange

        pattern.map do |pat|
            next pat unless pat.respond_to? :self_capture_group_rematch
            next pat unless pat.self_capture_group_rematch
            next pat unless tag_as?(pat.match)

            unless pat.arguments[:includes].nil? || pat.arguments[:includes].empty?
                raise "Cannot transform a Repeated pattern that has non empty includes"
            end

            pat.arguments[:includes] = [pat.match.__deep_clone__]
            pat.match.map! do |pm|
                pm.arguments.delete(:tag_as)
                pm.arguments.delete(:includes)
                next unless options[:preserve_references?] || pm.arguments[:preserve_references?]

                pm.self_scramble_references
            end
        end
    end

    #
    # Contributes the option :preserve_references?
    #
    # :preserve_references? disables the scrambling of references
    #
    # @return (see GrammarPlugin.options)
    #
    def self.options
        [:preserve_references?]
    end

    #
    # Displays the state of the options
    #
    # @return (see GrammarPlugin.display_options)
    #
    def self.display_options(indent, options)
        ",\n#{indent}preserve_references?: #{options[:preserve_references?]}"
    end
end

Grammar.register_transform(FixRepeatedTagAs.new, 99)