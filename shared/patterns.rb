def numeric_constant(grammar, allow_udl: false)
    # both C and C++ treat any sequence of digits, letter, periods, and valid seperators
    # as a single numeric constant even if such a sequence forms no valid
    # constant/literal
    # additionally +- are part of the sequence when immediately succeeding e,E,p, or P.
    # the outer range pattern does not attempt to actually process the numbers
    valid_single_character = /['0-9a-zA-Z_.']/
    valid_after_exponent = lookBehindFor(/[eEpP]/).then(/[+-]/)
    start_pattern = lookBehindToAvoid(/\w/).lookAheadFor(/\d/)
    end_pattern = lookAheadToAvoid(valid_single_character.or(valid_after_exponent))

    udl_pattern = allow_udl ?
        newPattern(
            match: /\w*/.then(end_pattern),
            tag_as: "keyword.other.unit.user-defined"
        ) : end_pattern

    grammar[:literal_numeric_seperator] = number_seperator_pattern = newPattern(
        should_fully_match: [ "'" ],
        should_partial_match: [ "1'1", "1'", "'1" ],
        should_not_partial_match: [ "1''1", "1''" ],
        match: lookBehindToAvoid(/'/).then(/'/).lookAheadToAvoid(/'/),
        tag_as:"punctuation.separator.constant.numeric",
        )

    hex_digits = hex_digits = newPattern(
        should_fully_match: [ "1", "123456", "DeAdBeeF", "49'30'94", "DeA'dBe'eF", "dea234f4930" ],
        should_not_fully_match: [ "'3902" , "de2300p1000", "0x000" ],
        should_not_partial_match: [ "p", "x", "." ],
        match: /[0-9a-fA-F]/.zeroOrMoreOf(/[0-9a-fA-F]/.or(number_seperator_pattern)),
        tag_as: "constant.numeric.hexadecimal",
        includes: [ number_seperator_pattern ],
        )
    decimal_digits = newPattern(
        should_fully_match: [ "1", "123456", "49'30'94" , "1'2" ],
        should_not_fully_match: [ "'3902" , "1.2", "0x000" ],
        match: /[0-9]/.zeroOrMoreOf(/[0-9]/.or(number_seperator_pattern)),
        tag_as: "constant.numeric.decimal",
        includes: [ number_seperator_pattern ],
        )
    octal_digits = newPattern(
        should_fully_match: [ "1", "123456", "47'30'74" , "1'2" ],
        should_not_fully_match: [ "'3902" , "1.2", "0x000" ],
        match: /[0-7]/.zeroOrMoreOf(/[0-7]/.or(number_seperator_pattern)),
        tag_as: "constant.numeric.octal",
        includes: [ number_seperator_pattern ],
        )
    binary_digits = newPattern(
        should_fully_match: [ "1", "100100", "10'00'11" , "1'0" ],
        should_not_fully_match: [ "'3902" , "1.2", "0x000" ],
        match: /[01]/.zeroOrMoreOf(/[01]/.or(number_seperator_pattern)),
        tag_as: "constant.numeric.binary",
        includes: [ number_seperator_pattern ],
        )

    hex_prefix = newPattern(
        should_fully_match: ["0x'", "0X'", "0x", "0X"],
        should_partial_match: ["0x1234"],
        should_not_partial_match: ["0b010x"],
        match: /\A/.then(/0[xX]/).maybe(number_seperator_pattern),
        tag_as: "keyword.other.unit.hexadecimal",
    )
    octal_prefix = newPattern(
        should_fully_match: ["0'", "0"],
        should_partial_match: ["01234"],
        match: /\A/.then(/0/).maybe(number_seperator_pattern),
        tag_as: "keyword.other.unit.octal",
    )
    binary_prefix = newPattern(
        should_fully_match: ["0b'", "0B'", "0b", "0B"],
        should_partial_match: ["0b1001"],
        should_not_partial_match: ["0x010b"],
        match: /\A/.then(/0[bB]/).maybe(number_seperator_pattern),
        tag_as: "keyword.other.unit.binary",
    )
    decimal_prefix = /\A/,
    numeric_suffix = newPattern(
        should_fully_match: ["u","l","UL","llU"],
        should_not_fully_match: ["lLu","uU","lug"],
        match: /[uU]/.or(/[uU]ll?/).or(/[uU]LL?/).or(/ll?[uU]?/).or(/LL?[uU]?/).lookAheadToAvoid(/\w/),
        tag_as: "keyword.other.unit.suffix.integer",
    )

    # see https://en.cppreference.com/w/cpp/language/floating_literal
    hex_exponent = newPattern(
        should_fully_match: [ "p100", "p-100", "p+100", "P100" ],
        should_not_fully_match: [ "p0x0", "p-+100" ],
        match: newPattern(
                match: /[pP]/,
                tag_as: "keyword.other.unit.exponent.hexadecimal",
            ).maybe(
                match: /\+/,
                tag_as: "keyword.operator.plus.exponent.hexadecimal",
            ).maybe(
                match: /\-/,
                tag_as: "keyword.operator.minus.exponent.hexadecimal",
            ).then(
                match: decimal_digits.without_numbered_capture_groups,
                tag_as: "constant.numeric.exponent.hexadecimal",
                includes: [ number_seperator_pattern ]
            ),
        )
    decimal_exponent = newPattern(
        should_fully_match: [ "e100", "e-100", "e+100", "E100", ],
        should_not_fully_match: [ "e0x0", "e-+100" ],
        match: newPattern(
                match: /[eE]/,
                tag_as: "keyword.other.unit.exponent.decimal",
            ).maybe(
                match: /\+/,
                tag_as: "keyword.operator.plus.exponent.decimal",
            ).maybe(
                match: /\-/,
                tag_as: "keyword.operator.minus.exponent.decimal",
            ).then(
                match: decimal_digits.without_numbered_capture_groups,
                tag_as: "constant.numeric.exponent.decimal",
                includes: [ number_seperator_pattern ]
            ),
        )
    hex_point = newPattern(
        # lookBehind/Ahead because there needs to be a hex digit on at least one side
        match: lookBehindFor(/[0-9a-fA-F]/).then(/\./).or(/\./.lookAheadFor(/[0-9a-fA-F]/)),
        tag_as: "constant.numeric.hexadecimal",
    )
    decimal_point = newPattern(
        # lookBehind/Ahead because there needs to be a decimal digit on at least one side
        match: lookBehindFor(/[0-9]/).then(/\./).or(/\./.lookAheadFor(/[0-9]/)),
        tag_as: "constant.numeric.decimal.point",
    )
    floating_suffix = newPattern(
        should_fully_match: ["f","l","L","F"],
        should_not_fully_match: ["lLu","uU","lug","fan"],
        match: /[lLfF]/.lookAheadToAvoid(/\w/),
        tag_as: "keyword.other.unit.suffix.floating-point"
    )

    return Range.new(
        start_pattern: start_pattern,
        end_pattern: end_pattern,
        # only a single include pattern should match
        includes: [
            # floating point
            hex_prefix.maybe(hex_digits).then(hex_point)
                .maybe(hex_digits).then(hex_exponent)
                .maybe(floating_suffix).then(udl_pattern),
            /\A/.maybe(decimal_digits).then(decimal_point)
                .maybe(decimal_digits).then(decimal_exponent)
                .maybe(floating_suffix).then(udl_pattern),
            # numeric
            binary_prefix.then(binary_digits).maybe(numeric_suffix).then(udl_pattern),
            octal_prefix.then(octal_digits).maybe(numeric_suffix).then(udl_pattern),
            hex_prefix.then(hex_digits).maybe(numeric_suffix).then(udl_pattern),
            /\A/.then(decimal_digits).maybe(numeric_suffix).then(udl_pattern),
            # invalid
            newPattern(
                match: valid_single_character.or(valid_after_exponent),
                tag_as: "invalid.illegal.constant.numeric"
            )
        ]
    )
end
