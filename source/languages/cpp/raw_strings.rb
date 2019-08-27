def generateTaggedRawString(name, tag_pattern, inner_pattern)
    return PatternRange.new(
        start_pattern: newPattern(
            match: newPattern(
                match: maybe(/[uUL]8?/).then(/R/),
                tag_as: "meta.encoding"
            ).then(/\"/).then(tag_pattern).then(/\(/),
            tag_as: "punctuation.definition.string.begin"
        ),
        end_pattern: newPattern(
            match: /\)/.then(tag_pattern).then(/\"/),
            tag_as: "punctuation.definition.string.end"
        ),
        tag_as: "string.quoted.double.raw.#{name}",
        includes: [
            inner_pattern,
        ]
    )
end

def getRawStringPatterns()
    # this does not use the new syntax as its requires a feature not yet supported
    default = {
        begin: "((?:u|u8|U|L)?R)\"(?:([^ ()\\\\\\t]{0,16})|([^ ()\\\\\\t]*))\\(",
        beginCaptures: {
            "0" => {
                name: "punctuation.definition.string.begin"
            },
            "1" => {
                name: "meta.encoding"
            },
            "3" => {
                name: "invalid.illegal.delimiter-too-long"
            }
        },
        end: "\\)\\2(\\3)\"",
        endCaptures: {
            "0" => {
                name: "punctuation.definition.string.end"
            },
            "1" => {
                name: "invalid.illegal.delimiter-too-long"
            }
        },
        name: "string.quoted.double.raw"
    }
    regex = generateTaggedRawString("regex", /_r/.or(/re/).or(/regex/), "source.regexp.python")
    sql = generateTaggedRawString("sql", /[pP]?(?:sql|SQL)/.or(/d[dm]l/), "source.sql")
    return [
        regex,
        sql,
        default,
    ]
end
