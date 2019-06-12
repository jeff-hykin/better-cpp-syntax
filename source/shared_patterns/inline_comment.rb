def inline_comment()
    newPattern(
        match: /\/\*/,
        tag_as: "comment.block punctuation.definition.comment.begin",
    ).then(
        match: /.+?/,
        tag_as: "comment.block",
    ).then(
        match: /\*\//,
        tag_as: "comment.block punctuation.definition.comment.end",
    )
end