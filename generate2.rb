require_relative './readable_grammar.rb'



unit_tag_name = "keyword.other.unit"
tick_mark_pattern = newPattern(/'/, tag_as: "punctuation.separator.constant.numeric")
hex_binary_or_octal_pattern = newPattern(
    # octal, hexadecimal, or binary start
    newPattern(
        /0/.lookAheadToAvoid(/[\.eE]/).maybe(/[xXbB]/, tag_as: 'pattern4'),
    # octal, hexadecimal, or binary contents
    ).thenNewPattern(
        /[0-9a-fA-F\.']+/,
        includes: [ tick_mark_pattern.to_tag ]
    ).maybe(
        # group #3 (unit)
        # hexadecimal_floating_constant start
        newPattern(
            /p/.or(/P/),
            tag_as: unit_tag_name
        ).maybe(
            newPattern(
                /\+/,
                tag_as: "keyword.operator.plus.exponent.hexadecimal-floating-point-literal",
            ).or(
                /\-/,
                tag_as: "keyword.operator.minus.exponent.hexadecimal-floating-point-literal",
            )
        # hexadecimal_floating_constant contents
        ).thenNewPattern(
            /[0-9']++/,
            includes: [ tick_mark_pattern.to_tag ]
        )
    ),
    global_name: :hex_binary_or_octal
)

literal_suffix = newPattern(
    hex_binary_or_octal_pattern.or(
        # decimal/base-10 start 
        newPattern(
            /[0-9\.][0-9\.']*/,
            includes: [ tick_mark_pattern.to_tag ]
        ).maybe(
            # scientific notation
            newPattern(
                /[eE]/,
                tag_as: unit_tag_name,
            ).maybe(
                # plus or minus symbols
                newPattern(
                    /\+/,
                    tag_as: "keyword.operator.plus.exponent",
                ).or(
                    /\-/,
                    tag_as: "keyword.operator.minus.exponent",
                )
            # exponent of scientific notation
            ).thenNewPattern(
                /[0-9']++/,
                includes: [ tick_mark_pattern.to_tag ]
            )
        )
    ),
    tag_as: 'pattern1'
# check if number is a custom literal
).thenNewPattern(
    zeroOrMoreOf(/[_a-zA-Z]/),
    tag_as: unit_tag_name
)
puts literal_suffix.to_tag