# frozen_string_literal: true
require 'ruby_grammar_builder'
require 'walk_up'
require_relative walk_up_until("paths.rb")


export = Grammar.new_exportable_grammar
# patterns that are imported
export.external_repos = [
    :line_continuation_character
]
# patterns that are exported
export.exports = [
    :line_comment,
    :inline_comment,
    :block_comment,
    :emacs_file_banner,
    :invalid_comment_end,
    :comments,
]
# (other :patterns can be created and used, but they will be namespace-randomized to keep them from ever conflicting/overwriting external patterns)

non_escaped_newline = lookBehindToAvoid(/\\/).oneOf([
    lookAheadFor(/\n/),
    lookBehindFor(/^\n|[^\\]\n/).lookAheadFor(/$/),
])

export[:line_comment] = PatternRange.new(
    tag_as: "comment.line.double-slash",
    start_pattern: Pattern.new(/\s*+/).then(
        match: /\/\//,
        tag_as: "punctuation.definition.comment"
    ),
    # a newline that doesnt have a line continuation
    end_pattern: non_escaped_newline,
    includes: [ :line_continuation_character ]
)

# 
# same as block_comment, but uses Pattern so it can be used inside other patterns
# 
export[:inline_comment] = Pattern.new(
    should_fully_match: [ "/* thing */", "/* thing *******/", "/* */", "/**/", "/***/" ],
    match: Pattern.new(
        Pattern.new(
            match: "/*",
            tag_as: "comment.block punctuation.definition.comment.begin",
        ).then(
            # this pattern is complicated because its optimized to never backtrack
            match: Pattern.new(
                tag_as: "comment.block",
                match: zeroOrMoreOf(
                    dont_back_track?: true,
                    match: Pattern.new(
                        Pattern.new(
                            /[^\*]++/
                        ).or(
                            Pattern.new(/\*+/).lookAheadToAvoid(/\//)
                        )
                    ),
                ).then(
                    match: "*/",
                    tag_as: "comment.block punctuation.definition.comment.end",
                )
            )
        )
    )    
)

# 
# same as inline but uses PatternRange to cover multiple lines
# 
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
    ),
    apply_end_pattern_last: true,
    includes: [
        # seems useless, but prevents issues like https://github.com/jeff-hykin/better-cpp-syntax/issues/527
        # note: this is more of a way to turn off the bailout for just this pattern when the macro_bailout is generated
        # it should be the only pattern that needs this because its the only thing that is run in phase1 of the 
        # preprocessor (e.g. before macros are handled)
        Pattern.new(/[^\*]*\n/),
    ],
)

# this is kind of a grandfathered-in pattern
export[:emacs_file_banner] = Pattern.new(
    #
    # file banner
    # this matches emacs style file banners ex: /* = foo.c = */
    # a file banner is a <comment start> <some spaces> <banner start> <some spaces>
    # <comment contents> <banner end> <some spaces> <comment end>
    # single line
    Pattern.new(
        should_fully_match: ["// ### test.c ###", "//=test.c - test util ="],
        should_not_partial_match: ["// ### test.c #=#", "//=test.c - test util ~~~"],
        match: Pattern.new(/^/).maybe(@spaces).then(
            match: Pattern.new(
                match: /\/\//,
                tag_as: "punctuation.definition.comment"
            ).maybe(
                match: @spaces,
            ).then(
                match: oneOrMoreOf(match: /[#;\/=*C~]+/, dont_back_track?: true).lookAheadToAvoid(/[#;\/=*C~]/),
                tag_as: "meta.banner.character",
                reference: "banner_part"
            ).maybe(@spaces).then(/.+/).maybe(@spaces).matchResultOf("banner_part")
            .maybe(@spaces).then(/(?:\n|$)/),
            tag_as: "comment.line.double-slash",
        ),
        # tag is a legacy name
        tag_as: "meta.toc-list.banner.double-slash",
    ).or(
        # should_fully_match: ["/* ### test.c ###*/", "/*=test.c - test util =*/"],
        # should_not_partial_match: ["/* ### test.c #=# */", "/*=test.c - test util ~~~*/"],
        match: Pattern.new(/^/).maybe(@spaces).then(
            match: Pattern.new(
                match: /\/\*/,
                tag_as: "punctuation.definition.comment"
            ).maybe(
                match: @spaces,
                quantity_preference: :as_few_as_possible
            ).then(
                match: oneOrMoreOf(match: /[#;\/=*C~]+/, dont_back_track?: true).lookAheadToAvoid(/[#;\/=*C~]/),
                tag_as: "meta.banner.character",
                reference: "banner_part2"
            ).maybe(@spaces).then(/.+/).maybe(@spaces).matchResultOf("banner_part2")
            .maybe(@spaces).then(/\*\//),
            tag_as: "comment.line.banner",
        ),
        # tag is a legacy name
        tag_as: "meta.toc-list.banner.block",
    )
)

export[:invalid_comment_end] = Pattern.new(
    match: /\*\//,
    tag_as: "invalid.illegal.unexpected.punctuation.definition.comment.end"
)

require_relative PathFor[:pattern]["doxygen"]

export[:comments] = [
    :emacs_file_banner,
    :block_comment,
    :line_comment,
    :invalid_comment_end,
]