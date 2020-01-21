def assembly_pattern(std_space, identifier)
    return PatternRange.new(
        tag_as: "meta.asm",
        start_pattern: Pattern.new(
            match: /\b(?:__asm__|asm)\b/,
            tag_as: "storage.type.asm",
        ).maybe(@spaces).maybe(
            match: /volatile/,
            tag_as: "storage.modifier",
        ),
        # match as soon as any characters are consumed and the inner patterns have finished
        end_pattern: lookAheadToAvoid(/\G/),
        includes: [
            # blank line
            Pattern.new(@start_of_line.then(std_space).then(@end_of_line)),
            # comments
            :comments_context,
            :comments,
            # outer most parens
            PatternRange.new(
                start_pattern: Pattern.new(
                    match: std_space.then(/\(/),
                    tag_as: "punctuation.section.parens.begin.bracket.round.assembly"
                ),
                end_pattern: Pattern.new(
                    match: /\)/,
                    tag_as: "punctuation.section.parens.end.bracket.round.assembly"
                ),
                includes: [
                    #asm string literals
                    PatternRange.new(
                        start_pattern: maybe(
                            match: /R/,
                                tag_as: "meta.encoding" # this is a temp name and should be improved once strings are improved
                            ).then(
                                match: /"/, 
                                tag_as: "punctuation.definition.string.begin.assembly"
                            ),
                        end_pattern: Pattern.new(match: /"/, tag_as: "punctuation.definition.string.end.assembly"),
                        tag_as: "string.quoted.double",
                        tag_content_as: "meta.embedded.assembly",
                        includes: [
                            "source.asm",
                            "source.x86",
                            "source.x86_64",
                            "source.arm",
                            :backslash_escapes,
                            :string_escaped_char,
                        ],
                    ),
                    # inner parens
                    PatternRange.new(
                        start_pattern: Pattern.new(
                            match: /\(/,
                            tag_as: "punctuation.section.parens.begin.bracket.round.assembly.inner",
                        ),
                        end_pattern: Pattern.new(
                            match: /\)/,
                            tag_as: "punctuation.section.parens.end.bracket.round.assembly.inner"
                        ),
                        includes: [
                            :evaluation_context
                        ]
                    ),
                    #symbolic names
                    Pattern.new(/\[/).then(std_space).then(
                        match: identifier,
                        tag_as: "variable.other.asm.label"
                    ).then(std_space).then(/\]/),
                    # colon delimiter
                    Pattern.new(
                        match: /:/,
                        tag_as: "punctuation.separator.delimiter.colon.assembly",
                    ),
                    :comments_context,
                    :comments,
                ],
            ),
        ],
    )
end