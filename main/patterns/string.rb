def string(start_pattern, end_pattern, includes:[], preceding_letters:nil)
    PatternRange.new(
        start_pattern: newPattern(
            match: start_pattern,
            tag_as: "punctuation.definition.string"
        ),
        end_pattern: newPattern(
            match: end_pattern,
            tag_as: "punctuation.definition.string"
        ),
        includes: includes,
    )
end

def escapes
    newPattern(
        match: /\\./,
        tag_as: "constant.character.escaped"
    )
end