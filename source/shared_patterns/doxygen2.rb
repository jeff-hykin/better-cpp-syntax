require_relative '../../../../directory'
require_relative PathFor[:textmate_tools]

# the tag_as for commands makes no sense but it is what jsdoc commands are tagged as
# (storage.type.class)

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
    "xrefitem"
]

paragraph_range_pattern_end = lookAheadFor(/[\\@](?:#{paragraph_commands.join("|")})/.or(/\*\//)).or(/\s++/.then(@end_of_line))

def generate_line_command_pattern(command_pattern, line_includes)
    Pattern.new(
        match: lookBehindFor(/[\s*!\/]/).then(/[\\@]/).then(command_pattern),
        tag_as: "storage.type.class.doxygen",
    ).then(@spaces).then(
        match: /.+/,
        includes: [
            PatternRange.new(
                start_pattern: lookAheadFor(/./),
                end_pattern: /$/,
                includes: line_includes
            )
        ],
    )
end

def generate_paragraph_command_pattern(command_pattern, first_line_includes, body_includes)
    PatternRange.new(
        tag_as: "meta.paragraph"
        start_pattern: lookBehindFor(/[\s*!\/]/).then(
                match: /[\\@]/.then(command_pattern),
                tag_as: "storage.type.class.doxygen",
            ).then(
                match: /.+/,
                includes: [
                    PatternRange.new(
                        start_pattern: lookAheadFor(/./),
                        end_pattern: /$/,
                        includes: includes: [
                            *first_line_includes,
                            *body_includes,
                        ],
                    )
                ],
            ),
        end_pattern: paragraph_range_pattern_end,
        includes: body_includes,

    )
end

Grammar.export(insert_namespace_infront_of_new_grammar_repos: true, insert_namespace_infront_of_all_included_repos: false) do |grammar, namespace|
    grammar[:standalone] = Pattern.new(
        match: lookBehindFor(/[\s*!\/]/).then(/[\\@]/).then(
            Pattern.new(/(?:#{standalone_command.map{|pat| Regexp.escape pat}.join("|")})/)
        ).then(/\b/).maybe(/\{[^}]*\}/),
        tag_as: "storage.type.class.doxygen"
    )
    # word commands
    grammar[:italics] = generate_word_command_pattern(/(?:a|em|e)/, "markup.italic.doxygen")
    grammar[:bold] = generate_word_command_pattern(/(?:b)/, "markup.bold.doxygen")
    grammar[:code] = generate_word_command_pattern(/(?:c|p)/, "markup.inline.raw.string.doxygen")
    grammar[:type_word] = generate_word_command_pattern(/(?:c|p)/, "entity.name.type.doxygen")
    grammar[:nontype_word] = generate_word_command_pattern(/(?:def|p)/, "variable.other.doxygen")
    grammar[:reference] = generate_word_command_pattern(/(?:anchor|cite|copybrief|copydetails|copydoc|)/, "constant.other.reference.doxygen")
    # line commands
    grammar[:type_line] = generate_word_command_pattern(/(?:class)/, [
        Pattern.new(
            match: Pattern.new(/\G\s++/).then(
                match: /\S+/,
                tag_as: "entity.name.type.doxygen"
            )
        )
    ])
    # paragraph commands
    grammar[:default_paragraph] = generate_word_command_pattern(/(?:arg|attention|authors?|brief|bug|copyright|date)/, [],[:standalone])
    # block commands
end