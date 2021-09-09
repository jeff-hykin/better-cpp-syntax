def line_continuation()
    Pattern.new(
        match: /\\/.lookAheadFor(/\n/),
        tag_as: "constant.character.escape.line-continuation"
    )
end