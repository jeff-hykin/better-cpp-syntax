def doxygen
    command_grammars = []
    # these commands are broken up by what part of the text they capture
    # - standalone: nothing
    # - word: The next word
    # - line: to the end of the line
    # - paragraph: until a blank line of another paragraph command is reached
    # - block: until the corrosponding endfoo command

    # if a command takes multiple arguments (not include {} arguments) it is treated as
    # at least line

    standalone_command = [
        "callergraph",
        "callgraph",
        "else",
        "endif",
        "f$",
        "f[",
        "f]",
        "hidecallergraph",
        "hidecallgraph",
        "hiderefby",
        "hiderefs",
        "hideinitializer",
        "htmlinclude",
        "n",
        "nosubgrouping",
        "private",
        "privatesection",
        "protected",
        "protectedsection",
        "public",
        "publicsection",
        "pure",
        "showinitializer",
        "showrefby",
        "showrefs",
        "tableofcontents",
        "$",
        "#",
        "<",
        ">",
        "%",
        "\"",
        ".",
        "=",
        "::",
        "|",
        "--",
        "---",
    ]

    command_grammars << Pattern.new(
        match: lookBehindFor(/[\s*!\/]/).then(/[\\@]/).then(
            Pattern.new(/(?:#{standalone_command.map{|pat| Regexp.escape pat}.join("|")})/)
        ).then(/\b/).maybe(/\{[^}]*\}/),
        # this tag_as makes no sense but it is what jsdoc commands are tagged as
        # (storage.type.class)
        tag_as: "storage.type.class.doxygen",
    )

    word_commands = [
        "a",
        "anchor",
        "b",
        "c",
        "cite",
        "copybrief",
        "copydetail",
        "copydoc",
        "def",
        "dir",
        "dontinclude",
        "e",
        "em",
        "emoji",
        "enum",
        "example",
        "extends",
        "file",
        "idlexcept",
        "implements",
        "include",
        "includedoc",
        "includelineno",
        "latexinclude",
        "link",
        "memberof",
        "namespace",
        "p",
        "package",
        "ref",
        "refitem",
        "related",
        "relates",
        "relatedalso",
        "relatesalso",
        "verbinclude",
    ]

    # italics
    command_grammars << Pattern.new(
        match: Pattern.new(
            match: lookBehindFor(/[\s*!\/]/).then(/[\\@]/).then(/(?:a|em|e)/),
            tag_as: "storage.type.class.doxygen",
        ).then(@spaces).then(
            match: /\S+/,
            tag_as: "markup.italic.doxygen",
        ),
    )

    # bold
    command_grammars << Pattern.new(
        match: Pattern.new(
            match: lookBehindFor(/[\s*!\/]/).then(/[\\@]/).then(/b/),
            tag_as: "storage.type.class.doxygen",
        ).then(@spaces).then(
            match: /\S+/,
            tag_as: "markup.bold.doxygen",
        ),
    )

    # inline code
    command_grammars << Pattern.new(
        match: Pattern.new(
            match: lookBehindFor(/[\s*!\/]/).then(/[\\@]/).then(/(?:c|p)/),
            tag_as: "storage.type.class.doxygen",
        ).then(@spaces).then(
            match: /\S+/,
            tag_as: "markup.inline.raw.string",
        ),
    )

    # TODO: make this consume and possibly reprocess the next word
    command_grammars << Pattern.new(
        match: lookBehindFor(/[\s*!\/]/).then(/[\\@]/).then(
            Pattern.new(/(?:#{word_commands.join("|")})/)
        ).then(/\b/).maybe(/\{[^}]*\}/),
        # this tag_as makes no sense but it is what jsdoc commands are tagged as
        # (storage.type.class)
        tag_as: "storage.type.class.doxygen",
    )

    line_commands = [
        "addindex",
        "addtogroup",
        "category",
        "class",
        "defgroup",
        "diafile",
        "dotfile",
        "elseif",
        "fn",
        "headerfile",
        "if",
        "ifnot",
        "image",
        "ingroup",
        "interface",
        "line",
        "mainpage",
        "mscfile",
        "name",
        "overload",
        "page",
        "property",
        "protocol",
        "section",
        "skip",
        "skipline",
        "snippet",
        "snippetdoc",
        "snippetlineno",
        "struct",
        "subpage",
        "subsection",
        "subsubsection",
        "typedef",
        "union",
        "until",
        "vhdlflow",
        "weakgroup",
    ]

    # TODO: make this consume and possibly reprocess the next line
    command_grammars << Pattern.new(
        match: lookBehindFor(/[\s*!\/]/).then(/[\\@]/).then(
            Pattern.new(/(?:#{line_commands.join("|")})/)
        ).then(/\b/).maybe(/\{[^}]*\}/),
        # this tag_as makes no sense but it is what jsdoc commands are tagged as
        # (storage.type.class)
        tag_as: "storage.type.class.doxygen",
    )

    paragraph_commands = [
        "arg",
        "attention",
        "author",
        "authors",
        "brief",
        "bug",
        "copyright",
        "date",
        "deprecated",
        "details",
        "exception",
        "invariant",
        "li",
        "note",
        "par",
        "paragraph",
        "param",
        "post",
        "pre",
        "remark",
        "remarks",
        "result",
        "return",
        "returns",
        "retval",
        "sa",
        "see",
        "short",
        "since",
        "test",
        "throw",
        "todo",
        "tparam",
        "version",
        "warning",
        "xrefitem",
    ]

    command_grammars << Pattern.new(
        match: Pattern.new(
            match: lookBehindFor(/[\s*!\/]/).then(/[\\@]/).then(/param/),
            tag_as: "storage.type.class.doxygen",
        ).then(@spaces).then(
            match: /\b\w+\b/,
            tag_as:"variable.parameter"
        )
    )
    # TODO: make this consume and possibly reprocess the next paragraph
    command_grammars << Pattern.new(
        match: lookBehindFor(/[\s*!\/]/).then(/[\\@]/).then(
            Pattern.new(/(?:#{paragraph_commands.join("|")})/)
        ).then(/\b/).maybe(/\{[^}]*\}/),
        # this tag_as makes no sense but it is what jsdoc commands are tagged as
        # (storage.type.class)
        tag_as: "storage.type.class.doxygen",
    )

    block_commands = [
        "code",
        "cond",
        "docbookonly",
        "dot",
        "htmlonly",
        "internal",
        "latexonly",
        "link",
        "manonly",
        "msc",
        "parblock",
        "rtfonly",
        "secreflist",
        "startuml",
        "verbatim",
        "xmlonly",
    ]

    with_end_blocks = [
        *block_commands,
        *block_commands.map do |block|
            block.gsub!("start", "")
            "end" + block
        end,
    ]

    # TODO: make this consume and possibly reprocess the next block
    command_grammars << Pattern.new(
        match: lookBehindFor(/[\s*!\/]/).then(/[\\@]/).then(
            Pattern.new(/(?:#{with_end_blocks.join("|")})/)
        ).then(/\b/).maybe(/\{[^}]*\}/),
        # this tag_as makes no sense but it is what jsdoc commands are tagged as
        # (storage.type.class)
        tag_as: "storage.type.class.doxygen",
    )

    # gtk doc
    command_grammars << Pattern.new(
        match: /\b[A-Z]+:/.or(/@[a-z_]+:/),
        tag_as: "storage.type.class.gtkdoc",
    )

    command_grammars << Pattern.new(
        match: /[\\@]\S++/.lookAheadToAvoid(@end_of_line),
        tag_as: "invalid.unknown.documentation.command",
    )

    line_comment = PatternRange.new(
        tag_as: "comment.line.documentation",
        start_pattern: Pattern.new(
            match: /\/\//.oneOrMoreOf(/[!\/]/),
            tag_as: "punctuation.definition.comment.documentation",
        ),
        while: @start_of_line.maybe(match: @spaces, dont_back_track?: true).then(
            match: /\/\//.oneOrMoreOf(/[!\/]/),
            tag_as: "punctuation.definition.comment.continuation.documentation",
        ),
        includes: command_grammars,
    )

    single_line_block_comment = Pattern.new(
        tag_as: "comment.block.documentation",
        match: Pattern.new(
            match: /\/\*/.oneOrMoreOf(/[!*]/).lookAheadFor(/\s/),
            tag_as: "punctuation.definition.comment.begin.documentation",
        ).then(
            match: oneOrMoreOf(/./),
            includes: command_grammars,
        ).then(
            match: zeroOrMoreOf(/[!*]/).then(/\*\//),
            tag_as: "punctuation.definition.comment.end.documentation",
        ),
    )

    block_comment = PatternRange.new(
        tag_as: "comment.block.documentation",
        start_pattern: Pattern.new(
            match: /\/\*/.oneOrMoreOf(/[!*]/).then(@end_of_line.or(lookAheadFor(/\s/))),
            tag_as: "punctuation.definition.comment.begin.documentation",
        ),
        end_pattern: Pattern.new(
            match: zeroOrMoreOf(/[!*]/).then(/\*\//),
            tag_as: "punctuation.definition.comment.end.documentation",
        ),
        includes: [
            PatternRange.new(
                start_pattern: /\G/,
                while: @start_of_line
                    .maybe(match: @spaces, dont_back_track?: true)
                    .lookAheadToAvoid(zeroOrMoreOf(/[!*]/).then(/\*\//))
                    .zeroOrMoreOf(
                        match: /\*/,
                        dont_back_track?: true,
                        tag_as: "punctuation.definition.comment.continuation.documentation",
                    ),
                includes: command_grammars,
            ),
            *command_grammars,
        ],
    )


    [line_comment, single_line_block_comment, block_comment]
end