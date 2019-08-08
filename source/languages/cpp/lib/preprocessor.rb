require_relative '../../../../directory'
require_relative PathFor[:textmate_tools]

Grammar.export(insert_namespace_infront_of_new_grammar_repos: true, insert_namespace_infront_of_all_included_repos: false) do |grammar, namespace|
    ->(std_space, identifier) do
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
        # 
        # #pragma
        # 
            grammar[:pragma_mark] = Pattern.new(
                tag_as: "meta.preprocessor.pragma",
                match: Pattern.new(
                    Pattern.new(
                        tag_as: "keyword.control.directive.pragma.pragma-mark",
                        match: directive_start.then(
                            match: /pragma/.then(@spaces).then(/mark/)
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
                    :string_context_c,
                    Pattern.new(
                        match: /[a-zA-Z_$][\w\-$]*/,
                        tag_as: "entity.other.attribute-name.pragma.preprocessor",
                    ),
                    :number_literal,
                    :line_continuation_character,
                ]
            )
        # 
        # #include
        # 
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
                            match: /include/.or(/include_next/).or(/import/),
                            reference: "include_type"
                        ).then(@word_boundary)
                    ),
                ).maybe(@spaces).then(
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
                        match: identifier.then(std_space).then(@end_of_line.or(lookAheadFor(/\/\//))),
                        tag_as: "entity.name.other.preprocessor.macro.include"
                    ).or(
                        # correctly color a lone `#include`
                        match: std_space.then(@end_of_line.or(lookAheadFor(/\/\//))),
                    )
                ),
                tag_as: "meta.preprocessor.include"
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
                    :string_context_c,
                    :number_literal,
                    :line_continuation_character,
                ]
            )
        # 
        # diagnostic (#error, #warning)
        # 
            grammar[:diagnostic] = PatternRange.new(
                tag_as: "meta.preprocessor.diagnostic",
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
                    ).then(std_space).then(
                        tag_as: "entity.name.function.preprocessor",
                        match: wordBounds(identifier),
                    )
                ),
            )
        # 
        # #define
        # 
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
                    ).maybe(@spaces).then(
                        match: identifier,
                        tag_as: "entity.name.function.preprocessor",
                    )
                ),
                end_pattern: non_escaped_newline,
                includes: [
                    # the parameters
                    PatternRange.new(
                        start_pattern: Pattern.new(
                            # find the name of the function
                            /\G/.maybe(@spaces).then(
                                match: /\(/,
                                tag_as: "punctuation.definition.parameters.begin",
                            )
                        ),
                        end_pattern: Pattern.new(
                            match: /\)/,
                            tag_as: "punctuation.definition.parameters.end"
                        ),
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
            # if
            # ifdef
            # ifndef
            # elif
            # else
            # endif
                grammar[:hacky_fix_for_stray_directive] = hacky_fix_for_stray_directive = Pattern.new(
                    match: wordBounds(/#(?:endif|else|elif)/),
                    tag_as: "keyword.control.directive.$match"
                )
        # return the preprocessor context
        [
            :pragma_mark,
            :pragma,
            :include,
            :line,
            :diagnostic,
            :undef,
            :macro,
            :hacky_fix_for_stray_directive,
            :macro_argument,
        ].map {|each| (namespace + each.to_s).to_sym }
    end
end