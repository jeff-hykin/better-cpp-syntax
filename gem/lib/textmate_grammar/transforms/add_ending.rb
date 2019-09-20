# frozen_string_literal: true

#
# Adds the last portion of the scope name to each tag_as if not already present
#
class AddEnding < GrammarTransform
    #
    # adds the ending to any tag_as in pattern if needed
    #
    def pre_transform(pattern, options)
        return pattern.map { |v| pre_transform(v, options) } if pattern.is_a? Array
        return pattern unless pattern.is_a? PatternBase

        ending = options[:grammar].scope_name.split(".")[-1]
        pattern.transform_tag_as do |tag_as|
            tag_as.split(" ").map do |tag|
                next tag if tag.end_with?(ending)

                tag + "." + ending
            end.join(" ")
        end
    end
end

Grammar.register_transform(AddEnding.new)