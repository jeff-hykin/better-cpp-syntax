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
                    # this is here because this pattern will not match if all of the includes above are not found.
                    # it never matches to ensure no overshoot
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