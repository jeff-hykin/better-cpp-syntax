def inline_comment()
    newPattern(
        match: /\/\*/,
        tag_as: "comment.block punctuation.definition.comment.begin",
    ).then(
        # this pattern is complicated because its optimized to never backtrack
        match: newPattern(
            tag_as: "comment.block",
            should_fully_match: [ "thing ****/", "/* thing */", "/* thing *******/" ],
            match: zeroOrMoreOf(
                dont_back_track?: true,
                match: newPattern(
                    newPattern(
                        /[^\*]/
                    ).or(
                        oneOrMoreOf(
                            match: /\*/,
                            dont_back_track?: true,
                        # any character that is not a /
                        ).then(/[^\/]/)
                    )
                ),
            ).then(
                should_fully_match: [ "*/", "*******/" ],
                match: newPattern(
                    oneOrMoreOf(
                        match: /\*/,
                        dont_back_track?: true,
                    ).then(/\//)
                ),
                includes: [
                    newPattern(
                        match: /\*\//,
                        tag_as: "comment.block punctuation.definition.comment.end"
                    ),
                    newPattern(
                        match: /\*/,
                        tag_as: "comment.block"
                    ),
                ]
            )
        )       
    )
end