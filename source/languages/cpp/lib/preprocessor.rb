def wordBounds(regex_pattern)
    return lookBehindToAvoid(@standard_character).then(regex_pattern).lookAheadToAvoid(@standard_character)
end

grammar = Grammar.new_exportable_grammar

grammar.external_repos = [
    :comments,
    :identifier,
    :language_constants,
    :line_continuation_character,
    :number_literal,
    :operators,
    :predefined_macros,
    :std_space,
    :string_context,
]
grammar.exports = [
    :macro_name,
    :pragma_mark,
    :pragma,
    :include,
    :line,
    :diagnostic,
    :undef,
    :single_line_macro,
    :macro,
    :macro_argument,
    :preprocessor_conditional_range,
    :preprocessor_conditional_context,
    :preprocessor_conditional_defined,
    :preprocessor_conditional_parentheses,
    :preprocessor_conditional_standalone,
    :preprocessor_context,
]

std_space = grammar[:std_space]
identifier = grammar[:identifier]

# specification source https://gcc.gnu.org/onlinedocs/cpp/

#
# helpers
#
    directive_start = Pattern.new(
        @start_of_line.then(std_space).then(
            match: /#/,
            tag_as: "punctuation.definition.directive",
        ).maybe(@spaces)
    )
    non_escaped_newline = lookBehindToAvoid(/\\/).lookAheadFor(/\n/)
    grammar[:macro_name] = macro_name = Pattern.new(
        match: wordBounds(identifier),
        tag_as: "entity.name.function.preprocessor",
    )
    grammar[:preprocessor_number_literal] = numeric_constant(allow_user_defined_literals: false).reTag(append:"preprocessor")
#
# #pragma
#
    grammar[:pragma_mark] = Pattern.new(
        tag_as: "meta.preprocessor.pragma",
        match: Pattern.new(
            Pattern.new(
                tag_as: "keyword.control.directive.pragma.pragma-mark",
                match: directive_start.then(
                    match: Pattern.new(/pragma/).then(@spaces).then(/mark/)
                ),
            ).then(@spaces).then(
                match: /.*/,
                tag_as: "entity.name.tag.pragma-mark",
            ),
        )
    )
    grammar[:pragma] = PatternRange.new(
        tag_as: "meta.preprocessor.pragma",
        start_pattern: Pattern.new(
            tag_as: "keyword.control.directive.pragma",
            match: directive_start.then(/pragma\b/)
        ),
        end_pattern: non_escaped_newline,
        includes: [
            :comments,
            :string_context,
            Pattern.new(
                match: /[a-zA-Z_$][\w\-$]*/,
                tag_as: "entity.other.attribute-name.pragma.preprocessor",
            ),
            :preprocessor_number_literal,
            :line_continuation_character,
        ]
    )
#
# #include
#
    include_partial = Pattern.new(
        Pattern.new(
            # system header [cpp.include]/2
            match: Pattern.new(
                match: /</,
                tag_as: "punctuation.definition.string.begin"
            ).zeroOrMoreOf(/[^>]/).maybe(
                match: />/,
                tag_as: "punctuation.definition.string.end"
            ).then(std_space).then(@end_of_line.or(lookAheadFor(/\/\//))),
            tag_as: "string.quoted.other.lt-gt.include"
        ).or(
            # other headers [cpp.include]/3
            match: Pattern.new(
                match: /\"/,
                tag_as: "punctuation.definition.string.begin"
            ).zeroOrMoreOf(/[^\"]/).maybe(
                match: /\"/,
                tag_as: "punctuation.definition.string.end"
            ).then(std_space).then(@end_of_line.or(lookAheadFor(/\/\//))),
            tag_as: "string.quoted.double.include"
        ).or(
            # macro includes [cpp.include]/4
            match: std_space.then(identifier).zeroOrMoreOf(/\./.then(identifier)).then(std_space).then(@end_of_line.or(lookAheadFor(/\/\//.or(/;/)))),
            tag_as: "entity.name.other.preprocessor.macro.include"
        ).or(
            # correctly color a lone `#include`
            match: std_space.then(@end_of_line.or(lookAheadFor(/\/\//.or(/;/)))),
        )
    )
    grammar[:include] = Pattern.new(
        should_fully_match: ["#include <cstdlib>", "#include \"my_header\"", "#include INC_HEADER","#include", "#include <typing"],
        should_partial_match: ["#include <foo> //comment"],
        match: @start_of_line.then(std_space).then(
            tag_as: "keyword.control.directive.$reference(include_type)",
            match: Pattern.new(
                Pattern.new(
                    match: /#/,
                    tag_as: "punctuation.definition.directive"
                ).maybe(@spaces).then(
                    match: /include/.or(/include_next/),
                    reference: "include_type"
                ).then(@word_boundary)
            ),
        ).maybe(@spaces).then(include_partial),
        tag_as: "meta.preprocessor.include"
    )
    grammar[:module_import] = Pattern.new(
        should_fully_match: ["import <cstdlib>", "import \"my_header\"", "import INC_HEADER","import", "import <typing"],
        should_partial_match: ["import <foo> //comment"],
        tag_as: "meta.preprocessor.import",
        match: @start_of_line.then(std_space).then(
            tag_as: "keyword.control.directive.import",
            match: Pattern.new(
                match: /import/,
                reference: "include_type",
            ),
        ).maybe(@spaces).then(include_partial).maybe(@spaces).maybe(
            match: /;/,
            tag_as: "punctuation.terminator.statement",
        ),
    )
#
# #line
#
    grammar[:line] = PatternRange.new(
        tag_as: "meta.preprocessor.line",
        start_pattern: Pattern.new(
            tag_as: "keyword.control.directive.line",
            match: directive_start.then(/line\b/)
        ),
        end_pattern: non_escaped_newline,
        includes: [
            :string_context,
            :preprocessor_number_literal,
            :line_continuation_character,
        ]
    )
#
# diagnostic (#error, #warning)
#
    grammar[:diagnostic] = PatternRange.new(
        tag_as: "meta.preprocessor.diagnostic.$reference(directive)",
        start_pattern: Pattern.new(
            Pattern.new(
                tag_as: "keyword.control.directive.diagnostic.$reference(directive)",
                match: directive_start.then(
                    match: /error/.or(/warning/),
                    reference: "directive"
                )
            ).then(@word_boundary).maybe(@spaces)
        ),
        end_pattern: non_escaped_newline,
        includes: [
            # double quotes
            PatternRange.new(
                tag_as: "string.quoted.double",
                start_pattern: Pattern.new(
                    match: /"/,
                    tag_as: "punctuation.definition.string.begin",
                ),
                end_pattern: Pattern.new(
                    Pattern.new(
                        match: /"/,
                        tag_as: "punctuation.definition.string.end",
                    ).or(
                        non_escaped_newline
                    )
                ),
                includes: [ :line_continuation_character ]
            ),
            # single quotes
            PatternRange.new(
                tag_as: "string.quoted.single",
                start_pattern: Pattern.new(
                    match: /'/,
                    tag_as: "punctuation.definition.string.begin",
                ),
                end_pattern: Pattern.new(
                    Pattern.new(
                        match: /'/,
                        tag_as: "punctuation.definition.string.end",
                    ).or(
                        non_escaped_newline
                    )
                ),
                includes: [ :line_continuation_character ]
            ),
            # unquoted
            PatternRange.new(
                tag_as: "string.unquoted",
                start_pattern: /[^'"]/,
                end_pattern: non_escaped_newline,
                includes: [
                    :line_continuation_character,
                    :comments,
                ]
            )
        ]
    )
#
# #undef
#
    grammar[:undef] = Pattern.new(
        tag_as: "meta.preprocessor.undef",
        match: Pattern.new(
            Pattern.new(
                tag_as: "keyword.control.directive.undef",
                match: directive_start.then(/undef\b/)
            ).then(std_space).then(macro_name)
        ),
    )
#
# #define
#
    grammar[:single_line_macro] = Pattern.new(
        should_fully_match: ['#define EXTERN_C extern "C"'],
        should_not_partial_match: ['#define test /* partial comment'],
        match: /^/.then(std_space).then(/#define/).oneOrMoreOf(oneOf([/[^\/]+/, /\/(?:[^*]|$)/])).lookBehindToAvoid(/[\\]/).then(@end_of_line),
        includes: [
            :macro,
            :comments,
        ]
    )
    grammar[:macro] = PatternRange.new(
        tag_as: "meta.preprocessor.macro",
        start_pattern: Pattern.new(
            # the directive
            Pattern.new(
                tag_as: "keyword.control.directive.define",
                match: directive_start.then(
                    /define\b/
                ),
            # the name of the directive
            ).maybe(@spaces).then(macro_name)
        ),
        end_pattern: non_escaped_newline,
        includes: [
            # the parameters
            Pattern.new(
                # find the name of the function
                /\G/.maybe(@spaces).then(
                    match: /\(/,
                    tag_as: "punctuation.definition.parameters.begin.preprocessor",
                ).then(
                    match: zeroOrMoreOf(/[^\(]/),
                    includes: [
                        # a parameter
                        Pattern.new(
                            lookBehindFor(/[(,]/).maybe(@spaces).then(
                                    match: identifier,
                                    tag_as: "variable.parameter.preprocessor"
                            ).maybe(@spaces)
                        ),
                        # commas
                        Pattern.new(
                            match: /,/,
                            tag_as: "punctuation.separator.parameters"
                        ),
                        # ellipses
                        Pattern.new(
                            match: /\.\.\./,
                            tag_as: "punctuation.vararg-ellipses.variable.parameter.preprocessor"
                        )
                    ]
                ).then(
                    match: /\)/,
                    tag_as: "punctuation.definition.parameters.end.preprocessor"
                )
            ),
            # everything after the parameters
            :macro_context,
            :macro_argument,
        ]

    )
#
# arguments
#
    grammar[:macro_argument] = Pattern.new(
        match: /##?/.then(identifier).lookAheadToAvoid(@standard_character),
        tag_as: "variable.other.macro.argument"
    )
#
# *conditionals*
#
    # this range only ends with #else and #endif and that decision is very intentional
    # by doing this the syntax safely closes double-starts or double-closes
    # (the if-true being case 1, and the if-false being case 2)
    # by only leaving one of the cases open (one of them has to be syntaxtically valid) this allows the grammar to parse the rest of it normally
    # there's more complexity behind this, but thats the general idea. See the github preprocessor conditional issues for full details
    grammar[:preprocessor_conditional_range] = PatternRange.new(
        start_pattern: Pattern.new(
            tag_as: "keyword.control.directive.conditional.$reference(conditional_name)",
            match: directive_start.then(
                match: /ifndef/.or(/ifdef/).or(/if/),
                reference: "conditional_name",
            )
        ),
        end_pattern: @start_of_line.lookAheadToAvoid(/\s*+#\s*(?:else|endif)/),
        includes: [
            # the first line (the conditional line)
            PatternRange.new(
                # start at the begining
                tag_as: "meta.preprocessor.conditional",
                start_pattern: /\G/.lookBehindFor(/ifndef|ifdef|if/),
                zeroLengthStart?: true,
                end_pattern: non_escaped_newline,
                includes: [ :preprocessor_conditional_context ],
            ),
            :$initial_context,
        ]
    )
    grammar[:preprocessor_conditional_context] = [
        :preprocessor_conditional_defined,
        :comments,
        :language_constants,
        :string_context,
        :preprocessor_number_literal,
        :operators,
        :predefined_macros,
        :macro_name,
        :line_continuation_character,
    ]
    grammar[:preprocessor_conditional_defined] = PatternRange.new(
        start_pattern: Pattern.new(
            Pattern.new(
                match: wordBounds(/defined/),
                tag_as: "keyword.control.directive.conditional.defined"
            ).then(
                match: /\(/,
                tag_as: "punctuation.section.parens.control.defined"
            )
        ),
        end_pattern: Pattern.new(
            match: /\)/.or(non_escaped_newline),
            tag_as: "punctuation.section.parens.control.defined"
        ),
        includes: [
            :macro_name,
        ]
    )
    grammar[:preprocessor_conditional_parentheses] = PatternRange.new(
        tag_as: "meta.parens.preprocessor.conditional",
        start_pattern: Pattern.new(
            match: /\(/,
            tag_as: "punctuation.section.parens.begin.bracket.round"
        ),
        end_pattern: Pattern.new(
            match: /\)/,
            tag_as: "punctuation.section.parens.end.bracket.round"
        ),
        include: [
            :preprocessor_conditional_context
        ]
    )
    grammar[:preprocessor_conditional_standalone] = Pattern.new(
        tag_as: "keyword.control.directive.$reference(conditional_name)",
        match: directive_start.then(
            match: wordBounds(/(?:endif|else|elif)/),
            reference: "conditional_name"
        )
    )

grammar[:preprocessor_context] = [
    :pragma_mark,
    :pragma,
    :include,
    :line,
    :diagnostic,
    :undef,
    :preprocessor_conditional_range,
    :single_line_macro,
    :macro,
    :preprocessor_conditional_standalone,
    :macro_argument,
]




