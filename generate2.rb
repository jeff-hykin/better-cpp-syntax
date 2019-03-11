require_relative './readable_grammar.rb'


unit_tag_name = "keyword.other.unit"
tick_mark_pattern = Pattern.new(match: /'/, tag_as: "punctuation.separator.constant.numeric")
hex_binary_or_octal_pattern = Pattern.new(
    global_name: :hex_binary_or_octal,
    # octal, hexadecimal, or binary start
    match: Pattern.new(
            match: /0/.lookAheadToAvoid(/[\.eE]/).maybe(/[xXbB]/),
            tag_as: unit_tag_name
        # octal, hexadecimal, or binary contents
        ).then(
            match: /[0-9a-fA-F\.']+/,
            includes: [ tick_mark_pattern ]
        ).maybe(
            # hexadecimal_floating_constant start
            Pattern.new(
                match: /p/.or(/P/),
                tag_as: unit_tag_name
            ).maybe(
                Pattern.new(
                    match: /\+/,
                    tag_as: "keyword.operator.plus.exponent.hexadecimal-floating-point-literal",
                ).or(
                    match: /\-/,
                    tag_as: "keyword.operator.minus.exponent.hexadecimal-floating-point-literal",
                )
            # hexadecimal_floating_constant contents
            ).then(
                match: /[0-9']++/,
                includes: [ tick_mark_pattern ]
            )
        )
)

literal_suffix = Pattern.new(
    hex_binary_or_octal_pattern.or(
        # decimal/base-10 start 
        Pattern.new(
            match: /[0-9\.][0-9\.']*/,
            includes: [ tick_mark_pattern ]
        ).maybe(
            # scientific notation
            Pattern.new(
                match: /[eE]/,
                tag_as: unit_tag_name,
            ).maybe(
                # plus or minus symbols
                Pattern.new(
                    match: /\+/,
                    tag_as: "keyword.operator.plus.exponent",
                ).or(
                    match: /\-/,
                    tag_as: "keyword.operator.minus.exponent",
                )
            # exponent of scientific notation
            ).then(
                match: /[0-9']++/,
                includes: [ tick_mark_pattern ]
            )
        )
    )
# check if number is a custom literal
).then(
    match: zeroOrMoreOf(/[_a-zA-Z]/),
    tag_as: unit_tag_name
)
puts hex_binary_or_octal_pattern.to_tag.to_json