require_relative 'base'

class AddEnding < GrammarTransform
    def pre_transform(key, pattern, grammar)
        return pattern.map {|v| pre_transform(key, v, grammar)} if pattern.is_a? Array
        return pattern unless pattern.is_a? Pattern
        ending = grammar.scope_name.split(".")[-1]
        pattern.transform_tag_as do |tag_as|
            puts tag_as
            tag_as.split(" ").map do |tag|
                next tag if tag.end_with?(ending)
                tag + "." + ending
            end.join(" ")
        end
    end
end

Grammar.register_transform(AddEnding.new())