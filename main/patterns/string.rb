def string(start_pattern, end_pattern, includes:[], preceding_letters:nil)
    PatternRange.new(
        start_pattern: Pattern.new(
            match: start_pattern,
            tag_as: "punctuation.definition.string"
        ),
        end_pattern: Pattern.new(
            match: end_pattern,
            tag_as: "punctuation.definition.string"
        ),
        includes: includes,
    )
end

def escapes
    Pattern.new(
        match: /\\./,
        tag_as: "constant.character.escaped"
    )
end
