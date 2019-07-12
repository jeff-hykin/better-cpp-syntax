def ever_present_context_for(context)
    [
        # preprocessor directives, which should be a part of every scope
        :single_line_macro,
        :preprocessor_rule_enabled,
        :preprocessor_rule_disabled,
        :preprocessor_rule_conditional,
        :meta_preprocessor_macro,
        :meta_preprocessor_diagnostic,
        :meta_preprocessor_include,
        :pragma_mark,
        :meta_preprocessor_line,
        :meta_preprocessor_undef,
        :meta_preprocessor_pragma,
        :hacky_fix_for_stray_directive,
        # comments 
        :comments,
        :line_continuation_character,
    ]
end