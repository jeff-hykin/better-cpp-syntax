# frozen_string_literal: true
require 'ruby_grammar_builder'
require 'walk_up'
require_relative walk_up_until("paths.rb")


export = Grammar.new_exportable_grammar
export.external_repos = [ # patterns that are imported
    :line_continuation_character
]
export.exports = [ # patterns that are exported
    :line_comment,
    :inline_comment,
    :block_comment,
    :comments,
]
# (other :patterns can be created and used, but they will be namespace-randomized to keep them from ever conflicting/overwriting external patterns)


# 
# //comment
# 
export[:line_comment] = PatternRange.new(
    tag_as: "comment.line.double-slash",
    start_pattern: Pattern.new(/\s*+/).then(
        match: /\/\//,
        tag_as: "punctuation.definition.comment"
    ),
    # a newline that doesnt have a line continuation
    end_pattern: lookBehindFor(/\n/).lookBehindToAvoid(/\\\n/),
    includes: [ :line_continuation_character ]
)

# 
# /*comment*/
# 
# same as block_comment, but uses Pattern so it can be used inside other patterns
export[:inline_comment] = Pattern.new(
    match: "/*",
    tag_as: "comment.block punctuation.definition.comment.begin",
).then(
    # this pattern is complicated because its optimized to never backtrack
    match: Pattern.new(
        tag_as: "comment.block",
        should_fully_match: [ "thing ****/", "/* thing */", "/* thing *******/" ],
        match: zeroOrMoreOf(
            dont_back_track?: true,
            match: Pattern.new(
                Pattern.new(
                    /[^\*]/
                ).or(
                    oneOrMoreOf(
                        match: "*",
                        dont_back_track?: true,
                    ).then(/[^\/]/) # any character that is not a /
                )
            ),
        ).then(
            should_fully_match: [ "*/", "*******/" ],
            match: Pattern.new(
                oneOrMoreOf(
                    match: "*",
                    dont_back_track?: true,
                ).then("/")
            ),
            includes: [
                Pattern.new(
                    match: "*/",
                    tag_as: "comment.block punctuation.definition.comment.end"
                ),
                Pattern.new(
                    match: "*",
                    tag_as: "comment.block"
                ),
            ]
        )
    )
)

# 
# /*comment*/
# 
# same as inline but uses PatternRange to cover multiple lines
export[:block_comment] = PatternRange.new(
    tag_as: "comment.block",
    start_pattern: Pattern.new(
        Pattern.new(/\s*+/).then(
            match: /\/\*/,
            tag_as: "punctuation.definition.comment.begin"
        )
    ),
    end_pattern: Pattern.new(
        match: /\*\//,
        tag_as: "punctuation.definition.comment.end"
    )
)

# 
# one group for both
# 
export[:comments] = [
    :block_comment,
    :line_comment,
]