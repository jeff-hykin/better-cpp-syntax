def line_continuation()
    newPattern(
        match: /\\/.lookAheadFor(/\n/),
        tag_as: "constant.character.escape.line-continuation"
    )
end