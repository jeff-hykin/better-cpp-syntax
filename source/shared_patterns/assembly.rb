def assembly_pattern()
    return PatternRange.new(
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
                start_pattern: newPattern(match: /"/, tag_as: "punctuation.definition.string.begin"),
                end_pattern: newPattern(match: /"/, tag_as: "punctuation.definition.string.end"),
                tag_as: "string.quoted.double",
                tag_content_as: "meta.embedded.assembly",
                includes: [
                    "source.asm",
                    "source.x86",
                    "source.x86_64",
                    "source.arm",
                    :string_escapes_context_c,
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
            :comments_context,
            :comments,
        ]
    )
end