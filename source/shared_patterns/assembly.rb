def assembly_pattern()
    return PatternRange.new(
        tag_as: "meta.asm",
        start_pattern: newPattern(
                match: /\b(?:__asm__|asm)\b/,
                tag_as: "storage.type.asm",
            ).maybe(@spaces).maybe(
                match: /volatile/,
                tag_as: "storage.modifier"
            ).maybe(@spaces).then(
                match: /\(/,
                tag_as: "punctuation.section.parens.begin.bracket.round.assembly",
            ),
        end_pattern: newPattern(
                match: /\)/,
                tag_as: "punctuation.section.parens.end.bracket.round.assembly"
            ),
        includes: [
                PatternRange.new(
                start_pattern: maybe(
                    match: /R/,
                        tag_as: "meta.encoding" # this is a temp name and should be improved once strings are improved
                    ).then(
                        match: /"/, 
                        tag_as: "punctuation.definition.string.begin.assembly"
                    ),
                end_pattern: newPattern(match: /"/, tag_as: "punctuation.definition.string.end.assembly"),
                tag_as: "string.quoted.double",
                tag_content_as: "meta.embedded.assembly",
                includes: [
                    "source.asm",
                    "source.x86",
                    "source.x86_64",
                    "source.arm",
                    :backslash_escapes,
                    :string_escaped_char,
                    # this is needed because, when a pattern's includes consists entirely of unresolved includes,
                    # the pattern's tags are not applied.
                    # The overall effect is that when the user has no assembly grammar, instead
                    # of seeing a string as before, the user sees unstyled text.
                    # This dummy pattern prevents that
                    lookAheadFor(/not/).then(/possible/)
                ] 
            ),
            PatternRange.new(
                start_pattern: newPattern(
                    match: /\(/,
                    tag_as: "punctuation.section.parens.begin.bracket.round.assembly.inner",
                ),
                end_pattern: newPattern(
                    match: /\)/,
                    tag_as: "punctuation.section.parens.end.bracket.round.assembly.inner"
                ),
                includes: [
                    :evaluation_context
                ]
            ),
            newPattern(
                match: /:/,
                tag_as: "punctuation.separator.delimiter.colon.assembly",
            ),
            :comments_context,
            :comments,
        ]
    )
end