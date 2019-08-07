require_relative '../../../../directory'
require_relative PathFor[:textmate_tools]

Grammar.export(insert_namespace_infront_of_new_grammar_repos: true, insert_namespace_infront_of_all_included_repos: false) do |grammar, namespace|
    ->(std_space) do
        # 
        # helpers
        # 
            directive_start = Pattern.new(
                @start_of_line.then(std_space).then(
                    match: /#/,
                    tag_as: "punctuation.definition.directive",
                ).maybe(@spaces)
            )
            non_escaped_newline = lookBehindToAvoid(/\\/).lookAheadFor(@end_of_line)
        # 
        # pragma
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
                    "#string_context_c",
                    Pattern.new(
                        match: /[a-zA-Z_$][\w\-$]*/,
                        tag_as: "entity.other.attribute-name.pragma.preprocessor",
                    ),
                    "#number_literal",
                    "#line_continuation_character",
                ]
            )
        # include
        # line
        # warning
        # error
        # undef
        # 
        # define
        # 
            grammar[:single_line_macro] = newPattern(
                    should_fully_match: ['#define EXTERN_C extern "C"'],
                    match: /^/.then(std_space).then(/#define/).then(/.*/).lookBehindToAvoid(/[\\]/).then(@end_of_line),
                    includes: [
                        :meta_preprocessor_macro,
                        :comments,
                        :string_context,
                        :number_literal,
                        :operators,
                        :semicolon,
                    ]
                )
        # arguments
        # *conditionals*
            # if
            # ifdef
            # ifndef
            # elif
            # else
            # endif
                grammar[:hacky_fix_for_stray_directive] = hacky_fix_for_stray_directive = newPattern(
                    match: wordBounds(/#(?:endif|else|elif)/),
                    tag_as: "keyword.control.directive.$match"
                )
        # return the preprocessor context
        [
            :pragma_mark,
            :pragma,
            :single_line_macro,
            :hacky_fix_for_stray_directive,
        ].map {|each| (namespace + each.to_s).to_sym }
    end
end