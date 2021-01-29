def c_style_control(keyword:"", primary_inlcudes:[],  parentheses_include:[], body_includes:[], secondary_includes:[])
    PatternRange.new(
        start_pattern: newPattern(
            /\s*+/.then(
                match: lookBehindToAvoid(@standard_character).then(/#{keyword}/).lookAheadToAvoid(@standard_character),
                tag_as: "keyword.control.#{keyword}"
            ).then(/\s*+/)
        ),
        end_pattern: newPattern(
            match: newPattern(
                match: /;/,
                tag_as: "punctuation.terminator.statement"
            ).or(
                match: /\}/,
                tag_as: "punctuation.section.block.control"
            )
        ),
        includes: [
            *primary_inlcudes,
            PatternRange.new(
                tag_content_as: "meta.control.evaluation",
                start_pattern: newPattern(
                    match: /\(/,
                    tag_as: "punctuation.section.parens.control",
                ),
                end_pattern: newPattern(
                    match: /\)/,
                    tag_as: "punctuation.section.parens.control",
                ),
                includes: parentheses_include
            ),
            PatternRange.new(
                tag_content_as: "meta.control.body",
                start_pattern: newPattern(
                    match: /\{/,
                    tag_as: "punctuation.section.block.control"
                ),
                end_pattern: lookAheadFor(/\}/),
                includes: body_includes
            ),
            *secondary_includes
        ]
    )
end