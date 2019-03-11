require_relative './readable_grammar.rb'



unit_tag_name = "keyword.other.unit"
tick_mark_pattern = newPattern(match: /'/, tag_as: "punctuation.separator.constant.numeric")
hex_binary_or_octal_pattern = newPattern(
    global_name: :hex_binary_or_octal,
    # octal, hexadecimal, or binary start
    match: newPattern(
            match: /0/.lookAheadToAvoid(/[\.eE]/).maybe(/[xXbB]/),
            tag_as: unit_tag_name
        # octal, hexadecimal, or binary contents
        ).thenNewPattern(
            match: /[0-9a-fA-F\.']+/,
            includes: [ tick_mark_pattern.to_tag ]
        ).maybe(
            # group #3 (unit)
            # hexadecimal_floating_constant start
            newPattern(
                match: /p/.or(/P/),
                tag_as: unit_tag_name
            ).maybe(
                newPattern(
                    match: /\+/,
                    tag_as: "keyword.operator.plus.exponent.hexadecimal-floating-point-literal",
                ).or(
                    match: /\-/,
                    tag_as: "keyword.operator.minus.exponent.hexadecimal-floating-point-literal",
                )
            # hexadecimal_floating_constant contents
            ).thenNewPattern(
                match: /[0-9']++/,
                includes: [ tick_mark_pattern ]
            )
        )
)

literal_suffix = newPattern(
    hex_binary_or_octal_pattern.or(
        # decimal/base-10 start 
        newPattern(
            match: /[0-9\.][0-9\.']*/,
            includes: [ tick_mark_pattern ]
        ).maybe(
            # scientific notation
            newPattern(
                match: /[eE]/,
                tag_as: unit_tag_name,
            ).maybe(
                # plus or minus symbols
                newPattern(
                    match: /\+/,
                    tag_as: "keyword.operator.plus.exponent",
                ).or(
                    match: /\-/,
                    tag_as: "keyword.operator.minus.exponent",
                )
            # exponent of scientific notation
            ).thenNewPattern(
                match: /[0-9']++/,
                includes: [ tick_mark_pattern ]
            )
        )
    )
# check if number is a custom literal
).thenNewPattern(
    match: zeroOrMoreOf(/[_a-zA-Z]/),
    tag_as: unit_tag_name
)
puts literal_suffix.to_tag.to_s.gsub(/,/, ",\n")