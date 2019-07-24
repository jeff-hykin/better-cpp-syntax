require_relative '../../../../directory'
require_relative PathFor[:textmate_tools]

patterns = {}
# 
# legacy
#
    patterns[:meta_preprocessor_macro] = {
            name: "meta.preprocessor.macro",
            begin: "(?x)\n^\\s* ((\\#)\\s*define) \\s+\t# define\n((?<id>#{preprocessor_name_no_bounds}))\t  # macro name\n(?:\n  (\\()\n\t(\n\t  \\s* \\g<id> \\s*\t\t # first argument\n\t  ((,) \\s* \\g<id> \\s*)*  # additional arguments\n\t  (?:\\.\\.\\.)?\t\t\t# varargs ellipsis?\n\t)\n  (\\))\n)?",
            beginCaptures: {
                "1" => {
                    name: "keyword.control.directive.define"
                },
                "2" => {
                    name: "punctuation.definition.directive"
                },
                "3" => {
                    name: "entity.name.function.preprocessor"
                },
                "5" => {
                    name: "punctuation.definition.parameters.begin"
                },
                "6" => {
                    name: "variable.parameter.preprocessor"
                },
                "8" => {
                    name: "punctuation.separator.parameters"
                },
                "9" => {
                    name: "punctuation.definition.parameters.end"
                }
            },
            end: "(?=(?://|/\\*))|(?<!\\\\)(?=\\n)",
            patterns: [
                {
                    include: "#macro_context"
                },
            ]
        }
    patterns[:meta_preprocessor_diagnostic] = {
            name: "meta.preprocessor.diagnostic",
            begin: "^\\s*((#)\\s*(error|warning))\\b\\s*",
            beginCaptures: {
                "1" => {
                    name: "keyword.control.directive.diagnostic.$3"
                },
                "2" => {
                    name: "punctuation.definition.directive"
                }
            },
            end: "(?<!\\\\)(?=\\n)",
            patterns: [
                {
                    begin: "\"",
                    beginCaptures: {
                        "0" => {
                            name: "punctuation.definition.string.begin"
                        }
                    },
                    end: "\"|(?<!\\\\)(?=\\s*\\n)",
                    endCaptures: {
                        "0" => {
                            name: "punctuation.definition.string.end"
                        }
                    },
                    name: "string.quoted.double",
                    patterns: [
                        {
                            include: "#line_continuation_character"
                        }
                    ]
                },
                {
                    begin: "'",
                    beginCaptures: {
                        "0" => {
                            name: "punctuation.definition.string.begin"
                        }
                    },
                    end: "'|(?<!\\\\)(?=\\s*\\n)",
                    endCaptures: {
                        "0" => {
                            name: "punctuation.definition.string.end"
                        }
                    },
                    name: "string.quoted.single",
                    patterns: [
                        {
                            include: "#line_continuation_character"
                        }
                    ]
                },
                {
                    begin: "[^'\"]",
                    end: "(?<!\\\\)(?=\\s*\\n)",
                    name: "string.unquoted.single",
                    patterns: [
                        {
                            include: "#line_continuation_character"
                        },
                        {
                            include: "#comments"
                        }
                    ]
                }
            ]
        }
    patterns[:meta_preprocessor_include] = {
            name: "meta.preprocessor.include",
            begin: "^\\s*((#)\\s*(include(?:_next)?|import))\\b\\s*",
            beginCaptures: {
                "1" => {
                    name: "keyword.control.directive.$3"
                },
                "2" => {
                    name: "punctuation.definition.directive"
                }
            },
            end: "(?=(?://|/\\*))|(?<!\\\\)(?=\\n)",
            patterns: [
                {
                    include: "#line_continuation_character"
                },
                {
                    begin: "\"",
                    beginCaptures: {
                        "0" => {
                            name: "punctuation.definition.string.begin"
                        }
                    },
                    end: "\"",
                    endCaptures: {
                        "0" => {
                            name: "punctuation.definition.string.end"
                        }
                    },
                    name: "string.quoted.double.include"
                },
                {
                    begin: "<",
                    beginCaptures: {
                        "0" => {
                            name: "punctuation.definition.string.begin"
                        }
                    },
                    end: ">",
                    endCaptures: {
                        "0" => {
                            name: "punctuation.definition.string.end"
                        }
                    },
                    name: "string.quoted.other.lt-gt.include"
                }
            ]
        }
    patterns[:meta_preprocessor_line] = {
            name: "meta.preprocessor",
            begin: "^\\s*((#)\\s*line)\\b",
            beginCaptures: {
                "1" => {
                    name: "keyword.control.directive.line"
                },
                "2" => {
                    name: "punctuation.definition.directive"
                }
            },
            end: "(?=(?://|/\\*))|(?<!\\\\)(?=\\n)",
            patterns: [
                {
                    include: "#string_context_c"
                },
                {
                    include: "#number_literal"
                },
                {
                    include: "#line_continuation_character"
                }
            ]
        }
    patterns[:meta_preprocessor_undef] = {
            name: "meta.preprocessor",
            begin: "^\\s*(?:((#)\\s*undef))\\b",
            beginCaptures: {
                "1" => {
                    name: "keyword.control.directive.undef"
                },
                "2" => {
                    name: "punctuation.definition.directive"
                }
            },
            end: "(?=(?://|/\\*))|(?<!\\\\)(?=\\n)",
            patterns: [
                {
                    match: preprocessor_name_no_bounds,
                    name: "entity.name.function.preprocessor"
                },
                {
                    include: "#line_continuation_character"
                }
            ]
        }
    patterns[:meta_preprocessor_pragma] = {
            name: "meta.preprocessor.pragma",
            begin: "^\\s*(?:((#)\\s*pragma))\\b",
            beginCaptures: {
                "1" => {
                    name: "keyword.control.directive.pragma"
                },
                "2" => {
                    name: "punctuation.definition.directive"
                }
            },
            end: "(?=(?://|/\\*))|(?<!\\\\)(?=\\n)",
            patterns: [
                {
                    include: "#string_context_c"
                },
                {
                    match: "[a-zA-Z_$][\\w\\-$]*",
                    name: "entity.other.attribute-name.pragma.preprocessor"
                },
                {
                    include: "#number_literal"
                },
                {
                    include: "#line_continuation_character"
                }
            ]
        }
    patterns[:pragma_mark] = {
        captures: {
            "1" => {
                name: "meta.preprocessor.pragma"
            },
            "2" => {
                name: "keyword.control.directive.pragma.pragma-mark"
            },
            "3" => {
                name: "punctuation.definition.directive"
            },
            "4" => {
                name: "entity.name.tag.pragma-mark"
            }
        },
        match: "^\\s*(((#)\\s*pragma\\s+mark)\\s+(.*))",
        name: "meta.section"
        }
    patterns[:preprocessor_rule_conditional] = {
            begin: "^\\s*((#)\\s*if(?:n?def)?\\b)",
            beginCaptures: {
                "0" => {
                    name: "meta.preprocessor"
                },
                "1" => {
                    name: "keyword.control.directive.conditional"
                },
                "2" => {
                    name: "punctuation.definition.directive"
                }
            },
            end: "^\\s*((#)\\s*endif\\b)",
            endCaptures: {
                "0" => {
                    name: "meta.preprocessor"
                },
                "1" => {
                    name: "keyword.control.directive.conditional"
                },
                "2" => {
                    name: "punctuation.definition.directive"
                }
            },
            patterns: [
                {
                    begin: "\\G(?=.)(?!//|/\\*(?!.*\\\\\\s*\\n))",
                    end: "(?=//)|(?=/\\*(?!.*\\\\\\s*\\n))|(?<!\\\\)(?=\\n)",
                    name: "meta.preprocessor",
                    patterns: [
                        {
                            include: "#preprocessor_rule_conditional_line_context"
                        }
                    ]
                },
                {
                    include: "#preprocessor_rule_enabled_elif"
                },
                {
                    include: "#preprocessor_rule_enabled_else"
                },
                {
                    include: "#preprocessor_rule_disabled_elif"
                },
                {
                    begin: "^\\s*((#)\\s*elif\\b)",
                    beginCaptures: {
                        "1" => {
                            name: "keyword.control.directive.conditional"
                        },
                        "2" => {
                            name: "punctuation.definition.directive"
                        }
                    },
                    end: "(?=//)|(?=/\\*(?!.*\\\\\\s*\\n))|(?<!\\\\)(?=\\n)",
                    name: "meta.preprocessor",
                    patterns: [
                        {
                            include: "#preprocessor_rule_conditional_line_context"
                        }
                    ]
                },
                {
                    include: "$initial_context"
                }
            ]
        }
    patterns[:preprocessor_rule_conditional_block] = {
            begin: "^\\s*((#)\\s*if(?:n?def)?\\b)",
            beginCaptures: {
                "0" => {
                    name: "meta.preprocessor"
                },
                "1" => {
                    name: "keyword.control.directive.conditional"
                },
                "2" => {
                    name: "punctuation.definition.directive"
                }
            },
            end: "^\\s*((#)\\s*endif\\b)",
            endCaptures: {
                "0" => {
                    name: "meta.preprocessor"
                },
                "1" => {
                    name: "keyword.control.directive.conditional"
                },
                "2" => {
                    name: "punctuation.definition.directive"
                }
            },
            patterns: [
                {
                    begin: "\\G(?=.)(?!//|/\\*(?!.*\\\\\\s*\\n))",
                    end: "(?=//)|(?=/\\*(?!.*\\\\\\s*\\n))|(?<!\\\\)(?=\\n)",
                    name: "meta.preprocessor",
                    patterns: [
                        {
                            include: "#preprocessor_rule_conditional_line_context"
                        }
                    ]
                },
                {
                    include: "#preprocessor_rule_enabled_elif_block"
                },
                {
                    include: "#preprocessor_rule_enabled_else_block"
                },
                {
                    include: "#preprocessor_rule_disabled_elif"
                },
                {
                    begin: "^\\s*((#)\\s*elif\\b)",
                    beginCaptures: {
                        "1" => {
                            name: "keyword.control.directive.conditional"
                        },
                        "2" => {
                            name: "punctuation.definition.directive"
                        }
                    },
                    end: "(?=//)|(?=/\\*(?!.*\\\\\\s*\\n))|(?<!\\\\)(?=\\n)",
                    name: "meta.preprocessor",
                    patterns: [
                        {
                            include: "#preprocessor_rule_conditional_line_context"
                        }
                    ]
                },
                {
                    include: "$initial_context"
                }
            ]
        }
    patterns[:preprocessor_rule_conditional_line_context] = [
            {
                match: "(?:\\bdefined\\b\\s*$)|(?:\\bdefined\\b(?=\\s*\\(*\\s*(?:(?!defined\\b)[a-zA-Z_$][\\w$]*\\b)\\s*\\)*\\s*(?:\\n|//|/\\*|\\?|\\:|&&|\\|\\||\\\\\\s*\\n)))",
                name: "keyword.control.directive.conditional"
            },
            {
                match: "\\bdefined\\b",
                name: "invalid.illegal.macro-name"
            },
            :comments,
            :string_context_c,
            :number_literal,
            {
                begin: "\\?",
                beginCaptures: {
                    "0" => {
                        name: "keyword.operator.ternary"
                    }
                },
                end: ":",
                endCaptures: {
                    "0" => {
                        name: "keyword.operator.ternary"
                    }
                },
                patterns: [
                    {
                        include: "#preprocessor_rule_conditional_line_context"
                    }
                ]
            },
            :operators,
            :language_constants,
            {
                match: preprocessor_name_no_bounds,
                name: "entity.name.function.preprocessor"
            },
            :line_continuation_character,
            {
                begin: "\\(",
                beginCaptures: {
                    "0" => {
                        name: "punctuation.section.parens.begin.bracket.round"
                    }
                },
                end: "\\)|(?=//)|(?=/\\*(?!.*\\\\\\s*\\n))|(?<!\\\\)(?=\\n)",
                endCaptures: {
                    "0" => {
                        name: "punctuation.section.parens.end.bracket.round"
                    }
                },
                patterns: [
                    {
                        include: "#preprocessor_rule_conditional_line_context"
                    }
                ]
            }
        ]
    patterns[:preprocessor_rule_disabled] = {
            begin: "^\\s*((#)\\s*if\\b)(?=\\s*\\(*\\b0+\\b\\)*\\s*(?:$|//|/\\*))",
            beginCaptures: {
                "0" => {
                    name: "meta.preprocessor"
                },
                "1" => {
                    name: "keyword.control.directive.conditional"
                },
                "2" => {
                    name: "punctuation.definition.directive"
                }
            },
            end: "^\\s*((#)\\s*endif\\b)",
            endCaptures: {
                "0" => {
                    name: "meta.preprocessor"
                },
                "1" => {
                    name: "keyword.control.directive.conditional"
                },
                "2" => {
                    name: "punctuation.definition.directive"
                }
            },
            patterns: [
                {
                    begin: "\\G(?=.)(?!//|/\\*(?!.*\\\\\\s*\\n))",
                    end: "(?=//)|(?=/\\*(?!.*\\\\\\s*\\n))|(?=\\n)",
                    name: "meta.preprocessor",
                    patterns: [
                        {
                            include: "#preprocessor_rule_conditional_line_context"
                        }
                    ]
                },
                {
                    include: "#comments"
                },
                {
                    include: "#preprocessor_rule_enabled_elif"
                },
                {
                    include: "#preprocessor_rule_enabled_else"
                },
                {
                    include: "#preprocessor_rule_disabled_elif"
                },
                {
                    begin: "^\\s*((#)\\s*elif\\b)",
                    beginCaptures: {
                        "0" => {
                            name: "meta.preprocessor"
                        },
                        "1" => {
                            name: "keyword.control.directive.conditional"
                        },
                        "2" => {
                            name: "punctuation.definition.directive"
                        }
                    },
                    end: "(?=^\\s*((#)\\s*(?:elif|else|endif)\\b))",
                    patterns: [
                        {
                            begin: "\\G(?=.)(?!//|/\\*(?!.*\\\\\\s*\\n))",
                            end: "(?=//)|(?=/\\*(?!.*\\\\\\s*\\n))|(?<!\\\\)(?=\\n)",
                            name: "meta.preprocessor",
                            patterns: [
                                {
                                    include: "#preprocessor_rule_conditional_line_context"
                                }
                            ]
                        },
                        {
                            include: "$initial_context"
                        }
                    ]
                },
                {
                    begin: "\\n",
                    end: "(?=^\\s*((#)\\s*(?:else|elif|endif)\\b))",
                    "contentName" => "comment.block.preprocessor.if-branch",
                    patterns: [
                        {
                            include: "#disabled"
                        },
                        {
                            include: "#pragma_mark"
                        }
                    ]
                }
            ]
        }
    patterns[:preprocessor_rule_disabled_block] = {
            begin: "^\\s*((#)\\s*if\\b)(?=\\s*\\(*\\b0+\\b\\)*\\s*(?:$|//|/\\*))",
            beginCaptures: {
                "0" => {
                    name: "meta.preprocessor"
                },
                "1" => {
                    name: "keyword.control.directive.conditional"
                },
                "2" => {
                    name: "punctuation.definition.directive"
                }
            },
            end: "^\\s*((#)\\s*endif\\b)",
            endCaptures: {
                "0" => {
                    name: "meta.preprocessor"
                },
                "1" => {
                    name: "keyword.control.directive.conditional"
                },
                "2" => {
                    name: "punctuation.definition.directive"
                }
            },
            patterns: [
                {
                    begin: "\\G(?=.)(?!//|/\\*(?!.*\\\\\\s*\\n))",
                    end: "(?=//)|(?=/\\*(?!.*\\\\\\s*\\n))|(?=\\n)",
                    name: "meta.preprocessor",
                    patterns: [
                        {
                            include: "#preprocessor_rule_conditional_line_context"
                        }
                    ]
                },
                {
                    include: "#comments"
                },
                {
                    include: "#preprocessor_rule_enabled_elif_block"
                },
                {
                    include: "#preprocessor_rule_enabled_else_block"
                },
                {
                    include: "#preprocessor_rule_disabled_elif"
                },
                {
                    begin: "^\\s*((#)\\s*elif\\b)",
                    beginCaptures: {
                        "0" => {
                            name: "meta.preprocessor"
                        },
                        "1" => {
                            name: "keyword.control.directive.conditional"
                        },
                        "2" => {
                            name: "punctuation.definition.directive"
                        }
                    },
                    end: "(?=^\\s*((#)\\s*(?:elif|else|endif)\\b))",
                    patterns: [
                        {
                            begin: "\\G(?=.)(?!//|/\\*(?!.*\\\\\\s*\\n))",
                            end: "(?=//)|(?=/\\*(?!.*\\\\\\s*\\n))|(?<!\\\\)(?=\\n)",
                            name: "meta.preprocessor",
                            patterns: [
                                {
                                    include: "#preprocessor_rule_conditional_line_context"
                                }
                            ]
                        },
                        {
                            include: "$initial_context"
                        }
                    ]
                },
                {
                    begin: "\\n",
                    end: "(?=^\\s*((#)\\s*(?:else|elif|endif)\\b))",
                    "contentName" => "comment.block.preprocessor.if-branch.in-block",
                    patterns: [
                        {
                            include: "#disabled"
                        },
                        {
                            include: "#pragma_mark"
                        }
                    ]
                }
            ]
        }
    patterns[:preprocessor_rule_disabled_elif] = {
        begin: "^\\s*((#)\\s*elif\\b)(?=\\s*\\(*\\b0+\\b\\)*\\s*(?:$|//|/\\*))",
        beginCaptures: {
            "0" => {
                name: "meta.preprocessor"
            },
            "1" => {
                name: "keyword.control.directive.conditional"
            },
            "2" => {
                name: "punctuation.definition.directive"
            }
        },
        end: "(?=^\\s*((#)\\s*(?:elif|else|endif)\\b))",
        patterns: [
            {
                begin: "\\G(?=.)(?!//|/\\*(?!.*\\\\\\s*\\n))",
                end: "(?=//)|(?=/\\*(?!.*\\\\\\s*\\n))|(?<!\\\\)(?=\\n)",
                name: "meta.preprocessor",
                patterns: [
                    {
                        include: "#preprocessor_rule_conditional_line_context"
                    }
                ]
            },
            {
                include: "#comments"
            },
            {
                begin: "\\n",
                end: "(?=^\\s*((#)\\s*(?:else|elif|endif)\\b))",
                "contentName" => "comment.block.preprocessor.elif-branch",
                patterns: [
                    {
                        include: "#disabled"
                    },
                    {
                        include: "#pragma_mark"
                    }
                ]
            }
        ]
        }
    patterns[:preprocessor_rule_enabled] = {
            begin: "^\\s*((#)\\s*if\\b)(?=\\s*\\(*\\b0*1\\b\\)*\\s*(?:$|//|/\\*))",
            beginCaptures: {
                "0" => {
                    name: "meta.preprocessor"
                },
                "1" => {
                    name: "keyword.control.directive.conditional"
                },
                "2" => {
                    name: "punctuation.definition.directive"
                },
                "3" => {
                    name: "constant.numeric.preprocessor"
                }
            },
            end: "^\\s*((#)\\s*endif\\b)",
            endCaptures: {
                "0" => {
                    name: "meta.preprocessor"
                },
                "1" => {
                    name: "keyword.control.directive.conditional"
                },
                "2" => {
                    name: "punctuation.definition.directive"
                }
            },
            patterns: [
                {
                    begin: "\\G(?=.)(?!//|/\\*(?!.*\\\\\\s*\\n))",
                    end: "(?=//)|(?=/\\*(?!.*\\\\\\s*\\n))|(?=\\n)",
                    name: "meta.preprocessor",
                    patterns: [
                        {
                            include: "#preprocessor_rule_conditional_line_context"
                        }
                    ]
                },
                {
                    include: "#comments"
                },
                {
                    begin: "^\\s*((#)\\s*else\\b)",
                    beginCaptures: {
                        "0" => {
                            name: "meta.preprocessor"
                        },
                        "1" => {
                            name: "keyword.control.directive.conditional"
                        },
                        "2" => {
                            name: "punctuation.definition.directive"
                        }
                    },
                    end: "(?=^\\s*((#)\\s*endif\\b))",
                    "contentName" => "comment.block.preprocessor.else-branch",
                    patterns: [
                        {
                            include: "#disabled"
                        },
                        {
                            include: "#pragma_mark"
                        }
                    ]
                },
                {
                    begin: "^\\s*((#)\\s*elif\\b)",
                    beginCaptures: {
                        "0" => {
                            name: "meta.preprocessor"
                        },
                        "1" => {
                            name: "keyword.control.directive.conditional"
                        },
                        "2" => {
                            name: "punctuation.definition.directive"
                        }
                    },
                    end: "(?=^\\s*((#)\\s*(?:else|elif|endif)\\b))",
                    "contentName" => "comment.block.preprocessor.if-branch",
                    patterns: [
                        {
                            include: "#disabled"
                        },
                        {
                            include: "#pragma_mark"
                        }
                    ]
                },
                {
                    begin: "\\n",
                    end: "(?=^\\s*((#)\\s*(?:else|elif|endif)\\b))",
                    patterns: [
                        {
                            include: "$initial_context"
                        }
                    ]
                }
            ]
        }
    patterns[:preprocessor_rule_enabled_block] = {
            begin: "^\\s*((#)\\s*if\\b)(?=\\s*\\(*\\b0*1\\b\\)*\\s*(?:$|//|/\\*))",
            beginCaptures: {
                "0" => {
                    name: "meta.preprocessor"
                },
                "1" => {
                    name: "keyword.control.directive.conditional"
                },
                "2" => {
                    name: "punctuation.definition.directive"
                }
            },
            end: "^\\s*((#)\\s*endif\\b)",
            endCaptures: {
                "0" => {
                    name: "meta.preprocessor"
                },
                "1" => {
                    name: "keyword.control.directive.conditional"
                },
                "2" => {
                    name: "punctuation.definition.directive"
                }
            },
            patterns: [
                {
                    begin: "\\G(?=.)(?!//|/\\*(?!.*\\\\\\s*\\n))",
                    end: "(?=//)|(?=/\\*(?!.*\\\\\\s*\\n))|(?=\\n)",
                    name: "meta.preprocessor",
                    patterns: [
                        {
                            include: "#preprocessor_rule_conditional_line_context"
                        }
                    ]
                },
                {
                    include: "#comments"
                },
                {
                    begin: "^\\s*((#)\\s*else\\b)",
                    beginCaptures: {
                        "0" => {
                            name: "meta.preprocessor"
                        },
                        "1" => {
                            name: "keyword.control.directive.conditional"
                        },
                        "2" => {
                            name: "punctuation.definition.directive"
                        }
                    },
                    end: "(?=^\\s*((#)\\s*endif\\b))",
                    "contentName" => "comment.block.preprocessor.else-branch.in-block",
                    patterns: [
                        {
                            include: "#disabled"
                        },
                        {
                            include: "#pragma_mark"
                        }
                    ]
                },
                {
                    begin: "^\\s*((#)\\s*elif\\b)",
                    beginCaptures: {
                        "0" => {
                            name: "meta.preprocessor"
                        },
                        "1" => {
                            name: "keyword.control.directive.conditional"
                        },
                        "2" => {
                            name: "punctuation.definition.directive"
                        }
                    },
                    end: "(?=^\\s*((#)\\s*(?:else|elif|endif)\\b))",
                    "contentName" => "comment.block.preprocessor.if-branch.in-block",
                    patterns: [
                        {
                            include: "#disabled"
                        },
                        {
                            include: "#pragma_mark"
                        }
                    ]
                },
                {
                    begin: "\\n",
                    end: "(?=^\\s*((#)\\s*(?:else|elif|endif)\\b))",
                    patterns: [
                        {
                            include: "$initial_context"
                        }
                    ]
                }
            ]

        }
    patterns[:preprocessor_rule_enabled_elif] = {
        begin: "^\\s*((#)\\s*elif\\b)(?=\\s*\\(*\\b0*1\\b\\)*\\s*(?:$|//|/\\*))",
        beginCaptures: {
            "0" => {
                name: "meta.preprocessor"
            },
            "1" => {
                name: "keyword.control.directive.conditional"
            },
            "2" => {
                name: "punctuation.definition.directive"
            }
        },
        end: "(?=^\\s*((#)\\s*endif\\b))",
        patterns: [
            {
                begin: "\\G(?=.)(?!//|/\\*(?!.*\\\\\\s*\\n))",
                end: "(?=//)|(?=/\\*(?!.*\\\\\\s*\\n))|(?<!\\\\)(?=\\n)",
                name: "meta.preprocessor",
                patterns: [
                    {
                        include: "#preprocessor_rule_conditional_line_context"
                    }
                ]
            },
            {
                include: "#comments"
            },
            {
                begin: "\\n",
                end: "(?=^\\s*((#)\\s*(?:endif)\\b))",
                patterns: [
                    {
                        begin: "^\\s*((#)\\s*(else)\\b)",
                        beginCaptures: {
                            "0" => {
                                name: "meta.preprocessor"
                            },
                            "1" => {
                                name: "keyword.control.directive.conditional"
                            },
                            "2" => {
                                name: "punctuation.definition.directive"
                            }
                        },
                        end: "(?=^\\s*((#)\\s*endif\\b))",
                        "contentName" => "comment.block.preprocessor.elif-branch",
                        patterns: [
                            {
                                include: "#disabled"
                            },
                            {
                                include: "#pragma_mark"
                            }
                        ]
                    },
                    {
                        begin: "^\\s*((#)\\s*(elif)\\b)",
                        beginCaptures: {
                            "0" => {
                                name: "meta.preprocessor"
                            },
                            "1" => {
                                name: "keyword.control.directive.conditional"
                            },
                            "2" => {
                                name: "punctuation.definition.directive"
                            }
                        },
                        end: "(?=^\\s*((#)\\s*(?:else|elif|endif)\\b))",
                        "contentName" => "comment.block.preprocessor.elif-branch",
                        patterns: [
                            {
                                include: "#disabled"
                            },
                            {
                                include: "#pragma_mark"
                            }
                        ]
                    },
                    {
                        include: "$initial_context"
                    }
                ]
            }
        ]
        }
    patterns[:preprocessor_rule_enabled_elif_block] = {
        begin: "^\\s*((#)\\s*elif\\b)(?=\\s*\\(*\\b0*1\\b\\)*\\s*(?:$|//|/\\*))",
        beginCaptures: {
            "0" => {
                name: "meta.preprocessor"
            },
            "1" => {
                name: "keyword.control.directive.conditional"
            },
            "2" => {
                name: "punctuation.definition.directive"
            }
        },
        end: "(?=^\\s*((#)\\s*endif\\b))",
        patterns: [
            {
                begin: "\\G(?=.)(?!//|/\\*(?!.*\\\\\\s*\\n))",
                end: "(?=//)|(?=/\\*(?!.*\\\\\\s*\\n))|(?<!\\\\)(?=\\n)",
                name: "meta.preprocessor",
                patterns: [
                    {
                        include: "#preprocessor_rule_conditional_line_context"
                    }
                ]
            },
            {
                include: "#comments"
            },
            {
                begin: "\\n",
                end: "(?=^\\s*((#)\\s*(?:endif)\\b))",
                patterns: [
                    {
                        begin: "^\\s*((#)\\s*(else)\\b)",
                        beginCaptures: {
                            "0" => {
                                name: "meta.preprocessor"
                            },
                            "1" => {
                                name: "keyword.control.directive.conditional"
                            },
                            "2" => {
                                name: "punctuation.definition.directive"
                            }
                        },
                        end: "(?=^\\s*((#)\\s*endif\\b))",
                        "contentName" => "comment.block.preprocessor.elif-branch.in-block",
                        patterns: [
                            {
                                include: "#disabled"
                            },
                            {
                                include: "#pragma_mark"
                            }
                        ]
                    },
                    {
                        begin: "^\\s*((#)\\s*(elif)\\b)",
                        beginCaptures: {
                            "0" => {
                                name: "meta.preprocessor"
                            },
                            "1" => {
                                name: "keyword.control.directive.conditional"
                            },
                            "2" => {
                                name: "punctuation.definition.directive"
                            }
                        },
                        end: "(?=^\\s*((#)\\s*(?:else|elif|endif)\\b))",
                        "contentName" => "comment.block.preprocessor.elif-branch",
                        patterns: [
                            {
                                include: "#disabled"
                            },
                            {
                                include: "#pragma_mark"
                            }
                        ]
                    },
                    {
                        include: "$initial_context"
                    }
                ]
            }
        ]
        }
    patterns[:preprocessor_rule_enabled_else] = {
        begin: "^\\s*((#)\\s*else\\b)",
        beginCaptures: {
            "0" => {
                name: "meta.preprocessor"
            },
            "1" => {
                name: "keyword.control.directive.conditional"
            },
            "2" => {
                name: "punctuation.definition.directive"
            }
        },
        end: "(?=^\\s*((#)\\s*endif\\b))",
        patterns: [
            {
                include: "$initial_context"
            }
        ]
        }
    patterns[:preprocessor_rule_enabled_else_block] = {
        begin: "^\\s*((#)\\s*else\\b)",
        beginCaptures: {
            "0" => {
                name: "meta.preprocessor"
            },
            "1" => {
                name: "keyword.control.directive.conditional"
            },
            "2" => {
                name: "punctuation.definition.directive"
            }
        },
        end: "(?=^\\s*((#)\\s*endif\\b))",
        patterns: [
            {
                include: "$initial_context"
            }
        ]
        }
    patterns[:preprocessor_rule_define_line_context] = [
            :vararg_ellipses,
            :macro_argument,
            {
                begin: "{",
                beginCaptures: {
                    "0" => {
                        name: "punctuation.section.block.begin.bracket.curly"
                    }
                },
                end: "}|(?=\\s*#\\s*(?:elif|else|endif)\\b)|(?<!\\\\)(?=\\s*\\n)",
                endCaptures: {
                    "0" => {
                        name: "punctuation.section.block.end.bracket.curly"
                    }
                },
                name: "meta.block",
                patterns: [
                    {
                        include: "#preprocessor_rule_define_line_blocks_context"
                    }
                ]
            },
            {
                match: "\\(",
                name: "punctuation.section.parens.begin.bracket.round"
            },
            {
                match: "\\)",
                name: "punctuation.section.parens.end.bracket.round"
            },
            {
                begin: "(?x)\n(?<![\\w$]|\\[)(?!(?:while|for|do|if|else|switch|catch|return|typeid|alignof|alignas|sizeof|and|and_eq|bitand|bitor|compl|not|not_eq|or|or_eq|typeid|xor|xor_eq|alignof|alignas|asm|__asm__|auto|bool|_Bool|char|_Complex|double|enum|float|_Imaginary|int|long|short|signed|struct|typedef|union|unsigned|void)\\s*\\()\n(?=\n  (?:[A-Za-z_][A-Za-z0-9_]*+|::)++\\s*\\(  # actual name\n  |\n  (?:(?<=operator)(?:[-*&<>=+!]+|\\(\\)|\\[\\]))\\s*\\(\n)",
                end: "(?<=\\))(?!\\w)|(?<!\\\\)(?=\\s*\\n)",
                name: "meta.function",
                patterns: [
                    {
                        include: "#preprocessor_rule_define_line_functions_context"
                    }
                ]
            },
            {
                begin: "\"",
                beginCaptures: {
                    "0" => {
                        name: "punctuation.definition.string.begin"
                    }
                },
                end: "\"|(?<!\\\\)(?=\\s*\\n)",
                endCaptures: {
                    "0" => {
                        name: "punctuation.definition.string.end"
                    }
                },
                name: "string.quoted.double",
                patterns: [
                    {
                        include: "#string_escapes_context_c"
                    },
                    {
                        include: "#line_continuation_character"
                    }
                ]
            },
            {
                begin: "'",
                beginCaptures: {
                    "0" => {
                        name: "punctuation.definition.string.begin"
                    }
                },
                end: "'|(?<!\\\\)(?=\\s*\\n)",
                endCaptures: {
                    "0" => {
                        name: "punctuation.definition.string.end"
                    }
                },
                name: "string.quoted.single",
                patterns: [
                    {
                        include: "#string_escapes_context_c"
                    },
                    {
                        include: "#line_continuation_character"
                    }
                ]
            },
            :$initial_context
        ]
    patterns[:preprocessor_rule_define_line_blocks_context] = [
            {
                begin: "{",
                beginCaptures: {
                    "0" => {
                        name: "punctuation.section.block.begin.bracket.curly"
                    }
                },
                end: "}|(?=\\s*#\\s*(?:elif|else|endif)\\b)|(?<!\\\\)(?=\\s*\\n)",
                endCaptures: {
                    "0" => {
                        name: "punctuation.section.block.end.bracket.curly"
                    }
                },
                patterns: [
                    {
                        include: "#preprocessor_rule_define_line_blocks_context"
                    },
                    {
                        include: "#preprocessor_rule_define_line_context"
                    }
                ]
            },
            {
                include: "#preprocessor_rule_define_line_context"
            }
        ]
    patterns[:preprocessor_rule_define_line_functions_context] = [
            :comments,
            :storage_types,
            :vararg_ellipses,
            :method_access,
            :member_access,
            :operators,
            {
                begin: "(?x)\n(?!(?:while|for|do|if|else|switch|catch|return|typeid|alignof|alignas|sizeof|and|and_eq|bitand|bitor|compl|not|not_eq|or|or_eq|typeid|xor|xor_eq|alignof|alignas)\\s*\\()\n(\n(?:[A-Za-z_][A-Za-z0-9_]*+|::)++  # actual name\n|\n(?:(?<=operator)(?:[-*&<>=+!]+|\\(\\)|\\[\\]))\n)\n\\s*(\\()",
                beginCaptures: {
                    "1" => {
                        name: "entity.name.function"
                    },
                    "2" => {
                        name: "punctuation.section.arguments.begin.bracket.round"
                    }
                },
                end: "(\\))|(?<!\\\\)(?=\\s*\\n)",
                endCaptures: {
                    "1" => {
                        name: "punctuation.section.arguments.end.bracket.round"
                    }
                },
                patterns: [
                    {
                        include: "#preprocessor_rule_define_line_functions_context"
                    }
                ]
            },
            {
                begin: "\\(",
                beginCaptures: {
                    "0" => {
                        name: "punctuation.section.parens.begin.bracket.round"
                    }
                },
                end: "(\\))|(?<!\\\\)(?=\\s*\\n)",
                endCaptures: {
                    "1" => {
                        name: "punctuation.section.parens.end.bracket.round"
                    }
                },
                patterns: [
                    {
                        include: "#preprocessor_rule_define_line_functions_context"
                    }
                ]
            },
            :preprocessor_rule_define_line_context
        ]
    






Grammar.export(patterns)