def c_style_control(keyword:"", primary_inlcudes:[],  paraentheses_include:[], body_includes:[], secondary_includes:[])
    PatternRange.new(
        start_pattern: newPattern(
            /\s*+/.then(
                match: /#{keyword}/,
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
                includes: paraentheses_include
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