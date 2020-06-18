require 'textmate_grammar'
require_relative '../../textmate_tools.rb'

@generate_tokens = ->(grammar) do
    grammar[ :_scope_resolution               ] = Pattern.new( match: "::"                            , adjectives: [ :isOperator,                                      :isBinaryOperator, :evaledLeftToRight, :isInFixOperator ] )
    grammar[ :_post_increment                 ] = Pattern.new( match: "++"                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isUrnaryOperator, :evaledLeftToRight, :isPostFixOperator ] )
    grammar[ :_post_decrement                 ] = Pattern.new( match: "--"                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isUrnaryOperator, :evaledLeftToRight, :isPostFixOperator ] )
    grammar[ :_function_call                  ] = Pattern.new( match: "()"                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword,                         :evaledLeftToRight,                         ] )
    grammar[ :_subscript                      ] = Pattern.new( match: "[]"                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword,                         :evaledLeftToRight,                         ] )
    grammar[ :_object_accessor                ] = Pattern.new( match: "."                             , adjectives: [ :isOperator,                                      :isBinaryOperator, :evaledLeftToRight, :isInFixOperator ] )
    grammar[ :_pointer_accessor               ] = Pattern.new( match: "->"                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledLeftToRight, :isInFixOperator ] )
    grammar[ :_pre_increment                  ] = Pattern.new( match: "++"                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isUrnaryOperator, :evaledRightToLeft, :isPreFixOperator ] )
    grammar[ :_pre_decrement                  ] = Pattern.new( match: "--"                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isUrnaryOperator, :evaledRightToLeft, :isPreFixOperator ] )
    grammar[ :_plus                           ] = Pattern.new( match: "+"                             , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isUrnaryOperator, :evaledRightToLeft, :isPreFixOperator ] )
    grammar[ :_minus                          ] = Pattern.new( match: "-"                             , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isUrnaryOperator, :evaledRightToLeft, :isPreFixOperator ] )
    grammar[ :_logic_not                      ] = Pattern.new( match: "!"                             , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isUrnaryOperator, :evaledRightToLeft, :isPreFixOperator , :isLogicicalOperator ] )
    grammar[ :_logic_not_word                 ] = Pattern.new( keyword: "not"                         , adjectives: [ :isOperator,                                      :isUrnaryOperator, :evaledRightToLeft, :isPreFixOperator , :isLogicicalOperator, :isOperatorAlias ] )
    grammar[ :_bitwise_not                    ] = Pattern.new( match: "~"                             , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isUrnaryOperator, :evaledRightToLeft, :isPreFixOperator ] )
    grammar[ :_bitwise_not_word               ] = Pattern.new( keyword: "compl"                       , adjectives: [ :isOperator,                                      :isUrnaryOperator, :evaledRightToLeft, :isPreFixOperator , :isOperatorAlias] )
    grammar[ :_dereference                    ] = Pattern.new( match: "*"                             , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isUrnaryOperator, :evaledRightToLeft, :isPreFixOperator ] )
    grammar[ :_reference                      ] = Pattern.new( match: "&"                             , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isUrnaryOperator, :evaledRightToLeft, :isPreFixOperator ] )
    grammar[ :_sizeof                         ] = Pattern.new( keyword: "sizeof"                      , adjectives: [ :isOperator,                                      :isUrnaryOperator, :evaledRightToLeft, :isPreFixOperator, :isFunctionLike ] )
    grammar[ :_variadic_sizeof                ] = Pattern.new( match: "sizeof..."                     , adjectives: [ :isOperator,                                      :isUrnaryOperator, :evaledRightToLeft, :isPreFixOperator, :isFunctionLike ] )
    grammar[ :_new                            ] = Pattern.new( keyword: "new"                         , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isUrnaryOperator, :evaledRightToLeft, :isPreFixOperator ] )
    grammar[ :_new_array                      ] = Pattern.new( match: "new[]"                         , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isUrnaryOperator, :evaledRightToLeft, :isPreFixOperator ] )
    grammar[ :_delete                         ] = Pattern.new( keyword: "delete"                      , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isUrnaryOperator, :evaledRightToLeft, :isPreFixOperator ] )
    grammar[ :_delete_array                   ] = Pattern.new( match: "delete[]"                      , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isUrnaryOperator, :evaledRightToLeft, :isPreFixOperator ] )
    grammar[ :_object_accessor_dereference    ] = Pattern.new( match: ".*"                            , adjectives: [ :isOperator,                                      :isBinaryOperator, :evaledLeftToRight, :isInFixOperator ] )
    grammar[ :_pointer_accessor_dereference   ] = Pattern.new( match: "->*"                           , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledLeftToRight, :isInFixOperator ] )
    grammar[ :_multiplication                 ] = Pattern.new( match: "*"                             , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledLeftToRight, :isInFixOperator ] )
    grammar[ :_division                       ] = Pattern.new( match: "/"                             , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledLeftToRight, :isInFixOperator ] )
    grammar[ :_modulus                        ] = Pattern.new( match: "%"                             , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledLeftToRight, :isInFixOperator ] )
    grammar[ :_addition                       ] = Pattern.new( match: "+"                             , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledLeftToRight, :isInFixOperator ] )
    grammar[ :_subtraction                    ] = Pattern.new( match: "-"                             , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledLeftToRight, :isInFixOperator ] )
    grammar[ :_bitwise_shift_left_assignment  ] = Pattern.new( match: "<<="                           , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledRightToLeft, :isInFixOperator , :isAssignmentOperator ] )
    grammar[ :_bitwise_shift_right_assignment ] = Pattern.new( match: ">>="                           , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledRightToLeft, :isInFixOperator , :isAssignmentOperator ] )
    grammar[ :_bitwise_shift_left             ] = Pattern.new( match: "<<"                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledLeftToRight, :isInFixOperator ] )
    grammar[ :_bitwise_shift_right            ] = Pattern.new( match: ">>"                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledLeftToRight, :isInFixOperator ] )
    grammar[ :_three_way_compare              ] = Pattern.new( match: "<=>"                           , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledLeftToRight, :isInFixOperator , :isComparisonOperator] )
    grammar[ :_less_than                      ] = Pattern.new( match: "<"                             , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledLeftToRight, :isInFixOperator , :isComparisonOperator] )
    grammar[ :_less_than_or_equal_to          ] = Pattern.new( match: "<="                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledLeftToRight, :isInFixOperator , :isComparisonOperator] )
    grammar[ :_greater_than                   ] = Pattern.new( match: ">"                             , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledLeftToRight, :isInFixOperator , :isComparisonOperator] )
    grammar[ :_greater_than_or_equal_to       ] = Pattern.new( match: ">="                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledLeftToRight, :isInFixOperator , :isComparisonOperator] )
    grammar[ :_equal_to                       ] = Pattern.new( match: "=="                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledLeftToRight, :isInFixOperator , :isComparisonOperator] )
    grammar[ :_not_equal_to                   ] = Pattern.new( match: "!="                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledLeftToRight, :isInFixOperator , :isComparisonOperator] )
    grammar[ :_not_equal_to_word              ] = Pattern.new( keyword: "not_eq"                      , adjectives: [ :isOperator,                                      :isBinaryOperator, :evaledLeftToRight, :isInFixOperator , :isComparisonOperator, :isOperatorAlias,] )
    grammar[ :_bitwise_and                    ] = Pattern.new( match: "&"                             , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledLeftToRight, :isInFixOperator ] )
    grammar[ :_bitwise_and_word               ] = Pattern.new( keyword: "bitand"                      , adjectives: [ :isOperator,                                      :isBinaryOperator, :evaledLeftToRight, :isInFixOperator , :isOperatorAlias] )
    grammar[ :_bitwise_xor                    ] = Pattern.new( match: "^"                             , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledLeftToRight, :isInFixOperator ] )
    grammar[ :_bitwise_xor_word               ] = Pattern.new( keyword: "xor"                         , adjectives: [ :isOperator,                                      :isBinaryOperator, :evaledLeftToRight, :isInFixOperator , :isOperatorAlias] )
    grammar[ :_bitwise_or                     ] = Pattern.new( match: "|"                             , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledLeftToRight, :isInFixOperator ] )
    grammar[ :_bitwise_or_word                ] = Pattern.new( keyword: "bitor"                       , adjectives: [ :isOperator,                                      :isBinaryOperator, :evaledLeftToRight, :isInFixOperator , :isOperatorAlias] )
    grammar[ :_logical_and                    ] = Pattern.new( match: "&&"                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledLeftToRight, :isInFixOperator , :isLogicicalOperator] )
    grammar[ :_logical_and_word               ] = Pattern.new( keyword: "and"                         , adjectives: [ :isOperator,                                      :isBinaryOperator, :evaledLeftToRight, :isInFixOperator , :isLogicicalOperator, :isOperatorAlias] )
    grammar[ :_logical_or                     ] = Pattern.new( match: "||"                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledLeftToRight, :isInFixOperator , :isLogicicalOperator] )
    grammar[ :_logical_or_word                ] = Pattern.new( keyword: "or"                          , adjectives: [ :isOperator,                                      :isBinaryOperator, :evaledLeftToRight, :isInFixOperator , :isLogicicalOperator, :isOperatorAlias] )
    grammar[ :_ternary_conditional            ] = Pattern.new( match: "?:"                            , adjectives: [ :isOperator,                                      :isTernaryOperator, :evaledRightToLeft,                         ] )
    grammar[ :_throw                          ] = Pattern.new( keyword: "throw"                       , adjectives: [ :isOperator,                                      :isUrnaryOperator, :evaledRightToLeft, :isPreFixOperator , :isControlFlow, :isExceptionRelated] )
    grammar[ :_direct_assignment              ] = Pattern.new( match: "="                             , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledRightToLeft, :isInFixOperator , :isAssignmentOperator ] )
    grammar[ :_addition_assignment            ] = Pattern.new( match: "+="                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledRightToLeft, :isInFixOperator , :isAssignmentOperator ] )
    grammar[ :_subtraction_assignment         ] = Pattern.new( match: "-="                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledRightToLeft, :isInFixOperator , :isAssignmentOperator ] )
    grammar[ :_multiplication_assignment      ] = Pattern.new( match: "*="                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledRightToLeft, :isInFixOperator , :isAssignmentOperator ] )
    grammar[ :_division_assignment            ] = Pattern.new( match: "/="                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledRightToLeft, :isInFixOperator , :isAssignmentOperator ] )
    grammar[ :_modulus_assignment             ] = Pattern.new( match: "%="                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledRightToLeft, :isInFixOperator , :isAssignmentOperator ] )
    grammar[ :_bitwise_and_assignment         ] = Pattern.new( match: "&="                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledRightToLeft, :isInFixOperator , :isAssignmentOperator ] )
    grammar[ :_bitwise_and_assignment_word    ] = Pattern.new( keyword: "and_eq"                      , adjectives: [ :isOperator,                                      :isBinaryOperator, :evaledRightToLeft, :isInFixOperator , :isAssignmentOperator , :isOperatorAlias] )
    grammar[ :_bitwise_xor_assignment         ] = Pattern.new( match: "^="                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledRightToLeft, :isInFixOperator , :isAssignmentOperator ] )
    grammar[ :_bitwise_xor_assignment_word    ] = Pattern.new( keyword: "xor_eq"                      , adjectives: [ :isOperator,                                      :isBinaryOperator, :evaledRightToLeft, :isInFixOperator , :isAssignmentOperator , :isOperatorAlias] )
    grammar[ :_bitwise_or_assignment          ] = Pattern.new( match: "|="                            , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledRightToLeft, :isInFixOperator , :isAssignmentOperator ] )
    grammar[ :_bitwise_or_assignment_word     ] = Pattern.new( keyword: "or_eq"                       , adjectives: [ :isOperator,                                      :isBinaryOperator, :evaledRightToLeft, :isInFixOperator , :isAssignmentOperator , :isOperatorAlias] )
    grammar[ :_comma                          ] = Pattern.new( match: ","                             , adjectives: [ :isOperator, :canAppearAfterOperatorKeyword, :isBinaryOperator, :evaledRightToLeft, :isInFixOperator ] )
    # no presedence
    grammar[ :_alignof                        ] = Pattern.new( keyword: "alignof"                     , adjectives: [ :isOperator,                                                                                                           :isFunctionLike ] )
    grammar[ :_alignas                        ] = Pattern.new( keyword: "alignas"                     , adjectives: [ :isOperator,                                                                                                           :isFunctionLike ] )
    grammar[ :_typeid                         ] = Pattern.new( keyword: "typeid"                      , adjectives: [ :isOperator,                                                                                                           :isFunctionLike ] )
    grammar[ :_noexcept                       ] = Pattern.new( keyword: "noexcept"                    , adjectives: [ :isOperator ] )
    grammar[ :_noexcept                       ] = Pattern.new( keyword: "noexcept"                    , adjectives: [ :isOperator,  :isFunctionLike ] )
    grammar[ :_static_cast                    ] = Pattern.new( keyword: "static_cast"                 , adjectives: [ :isOperator , :isTypeCastingOperator] )
    grammar[ :_dynamic_cast                   ] = Pattern.new( keyword: "dynamic_cast"                , adjectives: [ :isOperator , :isTypeCastingOperator] )
    grammar[ :_const_cast                     ] = Pattern.new( keyword: "const_cast"                  , adjectives: [ :isOperator , :isTypeCastingOperator] )
    grammar[ :_reinterpret_cast               ] = Pattern.new( keyword: "reinterpret_cast"            , adjectives: [ :isOperator , :isTypeCastingOperator] )
    # control
    grammar[ :_while                          ] = Pattern.new( keyword: "while"                       , adjectives: [ :isControlFlow, :requiresParentheseBlockImmediately, ] )
    grammar[ :_for                            ] = Pattern.new( keyword: "for"                         , adjectives: [ :isControlFlow, :requiresParentheseBlockImmediately, ] )
    grammar[ :_do                             ] = Pattern.new( keyword: "do"                          , adjectives: [ :isControlFlow,                                           ] )
    grammar[ :_if                             ] = Pattern.new( keyword: "if"                          , adjectives: [ :isControlFlow, :requiresParentheseBlockImmediately, ] )
    grammar[ :_else                           ] = Pattern.new( keyword: "else"                        , adjectives: [ :isControlFlow,                                           ] )
    grammar[ :_goto                           ] = Pattern.new( keyword: "goto"                        , adjectives: [ :isControlFlow,                                           ] )
    grammar[ :_switch                         ] = Pattern.new( keyword: "switch"                      , adjectives: [ :isControlFlow, :requiresParentheseBlockImmediately, ] )
    grammar[ :_try                            ] = Pattern.new( keyword: "try"                         , adjectives: [ :isControlFlow,                                           :isExceptionRelated] )
    grammar[ :_catch                          ] = Pattern.new( keyword: "catch"                       , adjectives: [ :isControlFlow, :requiresParentheseBlockImmediately, :isExceptionRelated] )
    grammar[ :_return                         ] = Pattern.new( keyword: "return"                      , adjectives: [ :isControlFlow,                                           :canAppearBeforeLambdaCapture ] )
    grammar[ :_break                          ] = Pattern.new( keyword: "break"                       , adjectives: [ :isControlFlow,                                           ] )
    grammar[ :_case                           ] = Pattern.new( keyword: "case"                        , adjectives: [ :isControlFlow,                                           ] )
    grammar[ :_continue                       ] = Pattern.new( keyword: "continue"                    , adjectives: [ :isControlFlow,                                           ] )
    grammar[ :_default                        ] = Pattern.new( keyword: "default"                     , adjectives: [ :isControlFlow,                                           ] )
    grammar[ :_co_await                       ] = Pattern.new( keyword: "co_await"                    , adjectives: [ :isControlFlow,                                           ] )
    grammar[ :_co_yield                       ] = Pattern.new( keyword: "co_yield"                    , adjectives: [ :isControlFlow,                                           ] )
    grammar[ :_co_return                      ] = Pattern.new( keyword: "co_return"                   , adjectives: [ :isControlFlow,                                           ] )
    # primitive type keywords
    # https://en.cppreference.com/w/cpp/language/types
    grammar[ :_auto                           ] = Pattern.new( keyword: "auto"                        , adjectives: [ :isPrimitive, :isType] )
    grammar[ :_void                           ] = Pattern.new( keyword: "void"                        , adjectives: [ :isPrimitive, :isType] )
    grammar[ :_char                           ] = Pattern.new( keyword: "char"                        , adjectives: [ :isPrimitive, :isType] )
    grammar[ :_short                          ] = Pattern.new( keyword: "short"                       , adjectives: [ :isPrimitive, :isType, :isTypeSpecifier] )
    grammar[ :_int                            ] = Pattern.new( keyword: "int"                         , adjectives: [ :isPrimitive, :isType] )
    grammar[ :_signed                         ] = Pattern.new( keyword: "signed"                      , adjectives: [ :isPrimitive, :isType, :isTypeSpecifier] )
    grammar[ :_unsigned                       ] = Pattern.new( keyword: "unsigned"                    , adjectives: [ :isPrimitive, :isType, :isTypeSpecifier] )
    grammar[ :_long                           ] = Pattern.new( keyword: "long"                        , adjectives: [ :isPrimitive, :isType, :isTypeSpecifier] )
    grammar[ :_float                          ] = Pattern.new( keyword: "float"                       , adjectives: [ :isPrimitive, :isType] )
    grammar[ :_double                         ] = Pattern.new( keyword: "double"                      , adjectives: [ :isPrimitive, :isType] )
    grammar[ :_bool                           ] = Pattern.new( keyword: "bool"                        , adjectives: [ :isPrimitive, :isType] )
    grammar[ :_wchar_t                        ] = Pattern.new( keyword: "wchar_t"                     , adjectives: [ :isPrimitive, :isType] )
    # other types
    grammar[ :_u_char               ] = Pattern.new( keyword: "u_char"                      , adjectives: [ :isType ] )
    grammar[ :_u_short              ] = Pattern.new( keyword: "u_short"                     , adjectives: [ :isType ] )
    grammar[ :_u_int                ] = Pattern.new( keyword: "u_int"                       , adjectives: [ :isType ] )
    grammar[ :_u_long               ] = Pattern.new( keyword: "u_long"                      , adjectives: [ :isType ] )
    grammar[ :_ushort               ] = Pattern.new( keyword: "ushort"                      , adjectives: [ :isType ] )
    grammar[ :_uint                 ] = Pattern.new( keyword: "uint"                        , adjectives: [ :isType ] )
    grammar[ :_u_quad_t             ] = Pattern.new( keyword: "u_quad_t"                    , adjectives: [ :isType ] )
    grammar[ :_quad_t               ] = Pattern.new( keyword: "quad_t"                      , adjectives: [ :isType ] )
    grammar[ :_qaddr_t              ] = Pattern.new( keyword: "qaddr_t"                     , adjectives: [ :isType ] )
    grammar[ :_caddr_t              ] = Pattern.new( keyword: "caddr_t"                     , adjectives: [ :isType ] )
    grammar[ :_daddr_t              ] = Pattern.new( keyword: "daddr_t"                     , adjectives: [ :isType ] )
    grammar[ :_div_t                ] = Pattern.new( keyword: "div_t"                       , adjectives: [ :isType ] )
    grammar[ :_dev_t                ] = Pattern.new( keyword: "dev_t"                       , adjectives: [ :isType ] )
    grammar[ :_fixpt_t              ] = Pattern.new( keyword: "fixpt_t"                     , adjectives: [ :isType ] )
    grammar[ :_blkcnt_t             ] = Pattern.new( keyword: "blkcnt_t"                    , adjectives: [ :isType ] )
    grammar[ :_blksize_t            ] = Pattern.new( keyword: "blksize_t"                   , adjectives: [ :isType ] )
    grammar[ :_gid_t                ] = Pattern.new( keyword: "gid_t"                       , adjectives: [ :isType ] )
    grammar[ :_in_addr_t            ] = Pattern.new( keyword: "in_addr_t"                   , adjectives: [ :isType ] )
    grammar[ :_in_port_t            ] = Pattern.new( keyword: "in_port_t"                   , adjectives: [ :isType ] )
    grammar[ :_ino_t                ] = Pattern.new( keyword: "ino_t"                       , adjectives: [ :isType ] )
    grammar[ :_key_t                ] = Pattern.new( keyword: "key_t"                       , adjectives: [ :isType ] )
    grammar[ :_mode_t               ] = Pattern.new( keyword: "mode_t"                      , adjectives: [ :isType ] )
    grammar[ :_nlink_t              ] = Pattern.new( keyword: "nlink_t"                     , adjectives: [ :isType ] )
    grammar[ :_id_t                 ] = Pattern.new( keyword: "id_t"                        , adjectives: [ :isType ] )
    grammar[ :_pid_t                ] = Pattern.new( keyword: "pid_t"                       , adjectives: [ :isType ] )
    grammar[ :_off_t                ] = Pattern.new( keyword: "off_t"                       , adjectives: [ :isType ] )
    grammar[ :_segsz_t              ] = Pattern.new( keyword: "segsz_t"                     , adjectives: [ :isType ] )
    grammar[ :_swblk_t              ] = Pattern.new( keyword: "swblk_t"                     , adjectives: [ :isType ] )
    grammar[ :_uid_t                ] = Pattern.new( keyword: "uid_t"                       , adjectives: [ :isType ] )
    grammar[ :_id_t                 ] = Pattern.new( keyword: "id_t"                        , adjectives: [ :isType ] )
    grammar[ :_clock_t              ] = Pattern.new( keyword: "clock_t"                     , adjectives: [ :isType ] )
    grammar[ :_size_t               ] = Pattern.new( keyword: "size_t"                      , adjectives: [ :isType ] )
    grammar[ :_ssize_t              ] = Pattern.new( keyword: "ssize_t"                     , adjectives: [ :isType ] )
    grammar[ :_time_t               ] = Pattern.new( keyword: "time_t"                      , adjectives: [ :isType ] )
    grammar[ :_useconds_t           ] = Pattern.new( keyword: "useconds_t"                  , adjectives: [ :isType ] )
    grammar[ :_suseconds_t          ] = Pattern.new( keyword: "suseconds_t"                 , adjectives: [ :isType ] )
    grammar[ :_int8_t               ] = Pattern.new( keyword: "int8_t"                      , adjectives: [ :isType ] )
    grammar[ :_int16_t              ] = Pattern.new( keyword: "int16_t"                     , adjectives: [ :isType ] )
    grammar[ :_int32_t              ] = Pattern.new( keyword: "int32_t"                     , adjectives: [ :isType ] )
    grammar[ :_int64_t              ] = Pattern.new( keyword: "int64_t"                     , adjectives: [ :isType ] )
    grammar[ :_uint8_t              ] = Pattern.new( keyword: "uint8_t"                     , adjectives: [ :isType ] )
    grammar[ :_uint16_t             ] = Pattern.new( keyword: "uint16_t"                    , adjectives: [ :isType ] )
    grammar[ :_uint32_t             ] = Pattern.new( keyword: "uint32_t"                    , adjectives: [ :isType ] )
    grammar[ :_uint64_t             ] = Pattern.new( keyword: "uint64_t"                    , adjectives: [ :isType ] )
    grammar[ :_int_least8_t         ] = Pattern.new( keyword: "int_least8_t"                , adjectives: [ :isType ] )
    grammar[ :_int_least16_t        ] = Pattern.new( keyword: "int_least16_t"               , adjectives: [ :isType ] )
    grammar[ :_int_least32_t        ] = Pattern.new( keyword: "int_least32_t"               , adjectives: [ :isType ] )
    grammar[ :_int_least64_t        ] = Pattern.new( keyword: "int_least64_t"               , adjectives: [ :isType ] )
    grammar[ :_uint_least8_t        ] = Pattern.new( keyword: "uint_least8_t"               , adjectives: [ :isType ] )
    grammar[ :_uint_least16_t       ] = Pattern.new( keyword: "uint_least16_t"              , adjectives: [ :isType ] )
    grammar[ :_uint_least32_t       ] = Pattern.new( keyword: "uint_least32_t"              , adjectives: [ :isType ] )
    grammar[ :_uint_least64_t       ] = Pattern.new( keyword: "uint_least64_t"              , adjectives: [ :isType ] )
    grammar[ :_int_fast8_t          ] = Pattern.new( keyword: "int_fast8_t"                 , adjectives: [ :isType ] )
    grammar[ :_int_fast16_t         ] = Pattern.new( keyword: "int_fast16_t"                , adjectives: [ :isType ] )
    grammar[ :_int_fast32_t         ] = Pattern.new( keyword: "int_fast32_t"                , adjectives: [ :isType ] )
    grammar[ :_int_fast64_t         ] = Pattern.new( keyword: "int_fast64_t"                , adjectives: [ :isType ] )
    grammar[ :_uint_fast8_t         ] = Pattern.new( keyword: "uint_fast8_t"                , adjectives: [ :isType ] )
    grammar[ :_uint_fast16_t        ] = Pattern.new( keyword: "uint_fast16_t"               , adjectives: [ :isType ] )
    grammar[ :_uint_fast32_t        ] = Pattern.new( keyword: "uint_fast32_t"               , adjectives: [ :isType ] )
    grammar[ :_uint_fast64_t        ] = Pattern.new( keyword: "uint_fast64_t"               , adjectives: [ :isType ] )
    grammar[ :_intptr_t             ] = Pattern.new( keyword: "intptr_t"                    , adjectives: [ :isType ] )
    grammar[ :_uintptr_t            ] = Pattern.new( keyword: "uintptr_t"                   , adjectives: [ :isType ] )
    grammar[ :_intmax_t             ] = Pattern.new( keyword: "intmax_t"                    , adjectives: [ :isType ] )
    grammar[ :_intmax_t             ] = Pattern.new( keyword: "intmax_t"                    , adjectives: [ :isType ] )
    grammar[ :_uintmax_t            ] = Pattern.new( keyword: "uintmax_t"                   , adjectives: [ :isType ] )
    grammar[ :_uintmax_t            ] = Pattern.new( keyword: "uintmax_t"                   , adjectives: [ :isType ] )
    grammar[ :_uintmax_t            ] = Pattern.new( keyword: "uintmax_t"                   , adjectives: [ :isType ] )
    # literals
    grammar[ :_NULL             ] = Pattern.new( keyword: "NULL"                        , adjectives: [ :isLiteral ] )
    grammar[ :_true             ] = Pattern.new( keyword: "true"                        , adjectives: [ :isLiteral ] )
    grammar[ :_false            ] = Pattern.new( keyword: "false"                       , adjectives: [ :isLiteral ] )
    grammar[ :_nullptr          ] = Pattern.new( keyword: "nullptr"                     , adjectives: [ :isLiteral ] )
    # type creators
    grammar[ :_class           ] = Pattern.new( keyword: "class"                       , adjectives: [ :isTypeCreator] )
    grammar[ :_struct          ] = Pattern.new( keyword: "struct"                      , adjectives: [ :isTypeCreator] )
    grammar[ :_union           ] = Pattern.new( keyword: "union"                       , adjectives: [ :isTypeCreator] )
    grammar[ :_enum            ] = Pattern.new( keyword: "enum"                        , adjectives: [ :isTypeCreator] )
    # storage specifiers https://en.cppreference.com/w/cpp/language/declarations 
    grammar[ :_const            ] = Pattern.new( keyword: "const"                       , adjectives: [ :isSpecifier, :isStorageSpecifier ] )
    grammar[ :_static           ] = Pattern.new( keyword: "static"                      , adjectives: [ :isSpecifier, :isStorageSpecifier ] )
    grammar[ :_volatile         ] = Pattern.new( keyword: "volatile"                    , adjectives: [ :isSpecifier, :isStorageSpecifier ] )
    grammar[ :_register         ] = Pattern.new( keyword: "register"                    , adjectives: [ :isSpecifier, :isStorageSpecifier ] )
    grammar[ :_restrict         ] = Pattern.new( keyword: "restrict"                    , adjectives: [ :isSpecifier, :isStorageSpecifier ] )
    grammar[ :_extern           ] = Pattern.new( keyword: "extern"                      , adjectives: [ :isSpecifier, :isStorageSpecifier, :isClassSpecifier ] )
    # function specifiers/qualifiers
    grammar[ :_inline           ] = Pattern.new( keyword: "inline"                      , adjectives: [ :isSpecifier , :isFunctionSpecifier] )
    grammar[ :_constexpr        ] = Pattern.new( keyword: "constexpr"                   , adjectives: [ :isSpecifier , :isFunctionSpecifier] )
    grammar[ :_mutable          ] = Pattern.new( keyword: "mutable"                     , adjectives: [ :isSpecifier , :isFunctionSpecifier] )
    grammar[ :_friend           ] = Pattern.new( keyword: "friend"                      , adjectives: [ :isSpecifier , :isFunctionSpecifier] )
    grammar[ :_explicit         ] = Pattern.new( keyword: "explicit"                    , adjectives: [ :isSpecifier , :isFunctionSpecifier] )
    grammar[ :_virtual          ] = Pattern.new( keyword: "virtual"                     , adjectives: [ :isSpecifier , :isFunctionSpecifier, :isInheritanceSpecifier ] )
    grammar[ :_final            ] = Pattern.new( keyword: "final"                       , adjectives: [ :functionQualifier, :canAppearAfterParametersBeforeBody , :isValidFunctionName, :isClassInheritenceSpecifier] )
    grammar[ :_override         ] = Pattern.new( keyword: "override"                    , adjectives: [ :functionQualifier, :canAppearAfterParametersBeforeBody , :isValidFunctionName, :isClassInheritenceSpecifier] )
    grammar[ :_volatile         ] = Pattern.new( keyword: "volatile"                    , adjectives: [ :functionQualifier, :canAppearAfterParametersBeforeBody ] )
    grammar[ :_const            ] = Pattern.new( keyword: "const"                       , adjectives: [ :functionQualifier, :canAppearAfterParametersBeforeBody ] )
    grammar[ :_noexcept         ] = Pattern.new( keyword: "noexcept"                    , adjectives: [ :isSpecifier ,      :canAppearAfterParametersBeforeBody ] )
    # if statement specifiers see https://en.cppreference.com/w/cpp/language/if
    grammar[ :_constexpr        ] = Pattern.new( keyword: "constexpr"                   , adjectives: [ :isSpecifier , :isIfStatementSpecifier ] )
    # lambda specifiers
    grammar[ :_mutable            ] = Pattern.new( keyword: "mutable"                       , adjectives: [ :isLambdaSpecifier ] )
    grammar[ :_constexpr          ] = Pattern.new( keyword: "constexpr"                     , adjectives: [ :isLambdaSpecifier ] )
    grammar[ :_consteval          ] = Pattern.new( keyword: "consteval"                     , adjectives: [ :isLambdaSpecifier ] )
    # accessor
    grammar[ :_private             ] = Pattern.new( keyword: "private"                      , adjectives: [ :isAccessSpecifier, :isInheritanceSpecifier ] )
    grammar[ :_protected           ] = Pattern.new( keyword: "protected"                    , adjectives: [ :isAccessSpecifier, :isInheritanceSpecifier ] )
    grammar[ :_public              ] = Pattern.new( keyword: "public"                       , adjectives: [ :isAccessSpecifier, :isInheritanceSpecifier ] )
    # pre processor directives
    grammar[ :_if                     ] = Pattern.new( keyword: "if"                           , adjectives: [ :isPreprocessorDirective ] )
    grammar[ :_elif                   ] = Pattern.new( keyword: "elif"                         , adjectives: [ :isPreprocessorDirective ] )
    grammar[ :_else                   ] = Pattern.new( keyword: "else"                         , adjectives: [ :isPreprocessorDirective ] )
    grammar[ :_endif                  ] = Pattern.new( keyword: "endif"                        , adjectives: [ :isPreprocessorDirective ] )
    grammar[ :_ifdef                  ] = Pattern.new( keyword: "ifdef"                        , adjectives: [ :isPreprocessorDirective ] )
    grammar[ :_ifndef                 ] = Pattern.new( keyword: "ifndef"                       , adjectives: [ :isPreprocessorDirective ] )
    grammar[ :_define                 ] = Pattern.new( keyword: "define"                       , adjectives: [ :isPreprocessorDirective ] )
    grammar[ :_undef                  ] = Pattern.new( keyword: "undef"                        , adjectives: [ :isPreprocessorDirective ] )
    grammar[ :_include                ] = Pattern.new( keyword: "include"                      , adjectives: [ :isPreprocessorDirective ] )
    grammar[ :_line                   ] = Pattern.new( keyword: "line"                         , adjectives: [ :isPreprocessorDirective ] )
    grammar[ :_error                  ] = Pattern.new( keyword: "error"                        , adjectives: [ :isPreprocessorDirective ] )
    grammar[ :_warning                ] = Pattern.new( keyword: "warning"                      , adjectives: [ :isPreprocessorDirective ] )
    grammar[ :_pragma                 ] = Pattern.new( keyword: "pragma"                       , adjectives: [ :isPreprocessorDirective ] )
    grammar[ :_pragma                 ] = Pattern.new( keyword: "_Pragma"                      , adjectives: [ :isPreprocessorDirective ] )
    grammar[ :_defined                ] = Pattern.new( keyword: "defined"                      , adjectives: [ :isPreprocessorDirective ] )
    grammar[ :___has_include          ] = Pattern.new( keyword: "__has_include"                , adjectives: [ :isPreprocessorDirective ] )
    grammar[ :___has_cpp_attribute    ] = Pattern.new( keyword: "__has_cpp_attribute"          , adjectives: [ :isPreprocessorDirective ] )

    # 
    # misc
    # 
    # https://en.cppreference.com/w/cpp/keyword
    grammar[ :_this          ] = Pattern.new( keyword: "this"                    )
    grammar[ :_template      ] = Pattern.new( keyword: "template"                )
    grammar[ :_namespace     ] = Pattern.new( keyword: "namespace"               )
    grammar[ :_using         ] = Pattern.new( keyword: "using"                   )
    grammar[ :_operator      ] = Pattern.new( keyword: "operator"                )
    # 
    grammar[ :_typedef       ] = Pattern.new( keyword: "typedef"                , adjectives: [ :isCurrentlyAMiscKeyword ] )
    grammar[ :_decltype      ] = Pattern.new( keyword: "decltype"               , adjectives: [ :isSpecifier,  :isFunctionLike ] )
    grammar[ :_typename      ] = Pattern.new( keyword: "typename"                )
    # 
    grammar[ :_asm                        ] = Pattern.new( keyword: "asm"                                )
    grammar[ :___asm__                    ] = Pattern.new( keyword: "__asm__"                            )
    # 
    grammar[ :_concept                    ] = Pattern.new( keyword: "concept"                           , adjectives: [ :isCurrentlyAMiscKeyword ] )
    grammar[ :_requires                   ] = Pattern.new( keyword: "requires"                          , adjectives: [ :isCurrentlyAMiscKeyword ] )
    grammar[ :_export                     ] = Pattern.new( keyword: "export"                            , adjectives: [ :isCurrentlyAMiscKeyword ] )
    grammar[ :_thread_local               ] = Pattern.new( keyword: "thread_local"                       )
    grammar[ :_atomic_cancel              ] = Pattern.new( keyword: "atomic_cancel"                      )
    grammar[ :_atomic_commit              ] = Pattern.new( keyword: "atomic_commit"                      )
    grammar[ :_atomic_noexcept            ] = Pattern.new( keyword: "atomic_noexcept"                    )
    grammar[ :_co_await                   ] = Pattern.new( keyword: "co_await"                           )
    grammar[ :_co_return                  ] = Pattern.new( keyword: "co_return"                          )
    grammar[ :_co_yield                   ] = Pattern.new( keyword: "co_yield"                           )
    grammar[ :_import                     ] = Pattern.new( keyword: "import"                             )
    grammar[ :_module                     ] = Pattern.new( keyword: "module"                            , adjectives: [ :isCurrentlyAMiscKeyword ] )
    grammar[ :_reflexpr                   ] = Pattern.new( keyword: "reflexpr"                           )
    grammar[ :_synchronized               ] = Pattern.new( keyword: "synchronized"                       )
    # 
    grammar[ :_audit                      ] = Pattern.new( keyword: "audit"                             , adjectives: [ :isSpecialIdentifier , :isValidFunctionName] )
    grammar[ :_axiom                      ] = Pattern.new( keyword: "axiom"                             , adjectives: [ :isSpecialIdentifier , :isValidFunctionName] )
    grammar[ :_transaction_safe           ] = Pattern.new( keyword: "transaction_safe"                  , adjectives: [ :isSpecialIdentifier , :isValidFunctionName] )
    grammar[ :_transaction_safe_dynamic   ] = Pattern.new( keyword: "transaction_safe_dynamic"          , adjectives: [ :isSpecialIdentifier , :isValidFunctionName] )
end
# 
# C++ specific tokens
# 
    # TODO: 
        # finish the specifiers https://en.cppreference.com/w/cpp/language/declarations 
        # https://en.cppreference.com/w/cpp/language/declarations
        # look at https://en.cppreference.com/w/cpp/language/function to implement better member function syntax

tokens = [
    # operators
    { representation: "::"                   , name: "scope-resolution"               , isOperator: true,                                      isBinaryOperator:  true, presedence:  1   , evaledLeftToRight: true, isInFixOperator:   true },
    { representation: "++"                   , name: "post-increment"                 , isOperator: true, canAppearAfterOperatorKeyword: true, isUrnaryOperator:  true, presedence:  2.1 , evaledLeftToRight: true, isPostFixOperator: true },
    { representation: "--"                   , name: "post-decrement"                 , isOperator: true, canAppearAfterOperatorKeyword: true, isUrnaryOperator:  true, presedence:  2.1 , evaledLeftToRight: true, isPostFixOperator: true },
    { representation: "()"                   , name: "function-call"                  , isOperator: true, canAppearAfterOperatorKeyword: true,                          presedence:  2.3 , evaledLeftToRight: true,                         },
    { representation: "[]"                   , name: "subscript"                      , isOperator: true, canAppearAfterOperatorKeyword: true,                          presedence:  2.4 , evaledLeftToRight: true,                         },
    { representation: "."                    , name: "object-accessor"                , isOperator: true,                                      isBinaryOperator:  true, presedence:  2.5 , evaledLeftToRight: true, isInFixOperator:   true },
    { representation: "->"                   , name: "pointer-accessor"               , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence:  2.5 , evaledLeftToRight: true, isInFixOperator:   true },
    { representation: "++"                   , name: "pre-increment"                  , isOperator: true, canAppearAfterOperatorKeyword: true, isUrnaryOperator:  true, presedence:  3.1 , evaledRightToLeft: true, isPreFixOperator:  true },
    { representation: "--"                   , name: "pre-decrement"                  , isOperator: true, canAppearAfterOperatorKeyword: true, isUrnaryOperator:  true, presedence:  3.1 , evaledRightToLeft: true, isPreFixOperator:  true },
    { representation: "+"                    , name: "plus"                           , isOperator: true, canAppearAfterOperatorKeyword: true, isUrnaryOperator:  true, presedence:  3.2 , evaledRightToLeft: true, isPreFixOperator:  true },
    { representation: "-"                    , name: "minus"                          , isOperator: true, canAppearAfterOperatorKeyword: true, isUrnaryOperator:  true, presedence:  3.2 , evaledRightToLeft: true, isPreFixOperator:  true },
    { representation: "!"                    , name: "logic-not"                      , isOperator: true, canAppearAfterOperatorKeyword: true, isUrnaryOperator:  true, presedence:  3.3 , evaledRightToLeft: true, isPreFixOperator:  true , isLogicicalOperator: true },
    { representation: "not"                  , name: "logic-not-word"                 , isOperator: true,                                      isUrnaryOperator:  true, presedence:  3.3 , evaledRightToLeft: true, isPreFixOperator:  true , isLogicicalOperator: true, isOperatorAlias: true },
    { representation: "~"                    , name: "bitwise-not"                    , isOperator: true, canAppearAfterOperatorKeyword: true, isUrnaryOperator:  true, presedence:  3.3 , evaledRightToLeft: true, isPreFixOperator:  true },
    { representation: "compl"                , name: "bitwise-not-word"               , isOperator: true,                                      isUrnaryOperator:  true, presedence:  3.3 , evaledRightToLeft: true, isPreFixOperator:  true , isOperatorAlias: true},
    { representation: "*"                    , name: "dereference"                    , isOperator: true, canAppearAfterOperatorKeyword: true, isUrnaryOperator:  true, presedence:  3.5 , evaledRightToLeft: true, isPreFixOperator:  true },
    { representation: "&"                    , name: "reference"                      , isOperator: true, canAppearAfterOperatorKeyword: true, isUrnaryOperator:  true, presedence:  3.6 , evaledRightToLeft: true, isPreFixOperator:  true },
    { representation: "sizeof"               , name: "sizeof"                         , isOperator: true,                                      isUrnaryOperator:  true, presedence:  3.7 , evaledRightToLeft: true, isPreFixOperator:  true, isFunctionLike: true },
    { representation: "sizeof..."            , name: "variadic-sizeof"                , isOperator: true,                                      isUrnaryOperator:  true, presedence:  3.7 , evaledRightToLeft: true, isPreFixOperator:  true, isFunctionLike: true },
    { representation: "new"                  , name: "new"                            , isOperator: true, canAppearAfterOperatorKeyword: true, isUrnaryOperator:  true, presedence:  3.8 , evaledRightToLeft: true, isPreFixOperator:  true },
    { representation: "new[]"                , name: "new-array"                      , isOperator: true, canAppearAfterOperatorKeyword: true, isUrnaryOperator:  true, presedence:  3.8 , evaledRightToLeft: true, isPreFixOperator:  true },
    { representation: "delete"               , name: "delete"                         , isOperator: true, canAppearAfterOperatorKeyword: true, isUrnaryOperator:  true, presedence:  3.9 , evaledRightToLeft: true, isPreFixOperator:  true },
    { representation: "delete[]"             , name: "delete-array"                   , isOperator: true, canAppearAfterOperatorKeyword: true, isUrnaryOperator:  true, presedence:  3.9 , evaledRightToLeft: true, isPreFixOperator:  true },
    { representation: ".*"                   , name: "object-accessor-dereference"    , isOperator: true,                                      isBinaryOperator:  true, presedence:  4   , evaledLeftToRight: true, isInFixOperator:   true },
    { representation: "->*"                  , name: "pointer-accessor-dereference"   , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence:  4   , evaledLeftToRight: true, isInFixOperator:   true },
    { representation: "*"                    , name: "multiplication"                 , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence:  5   , evaledLeftToRight: true, isInFixOperator:   true },
    { representation: "/"                    , name: "division"                       , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence:  5   , evaledLeftToRight: true, isInFixOperator:   true },
    { representation: "%"                    , name: "modulus"                        , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence:  5   , evaledLeftToRight: true, isInFixOperator:   true },
    { representation: "+"                    , name: "addition"                       , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence:  6   , evaledLeftToRight: true, isInFixOperator:   true },
    { representation: "-"                    , name: "subtraction"                    , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence:  6   , evaledLeftToRight: true, isInFixOperator:   true },
    { representation: "<<="                  , name: "bitwise-shift-left-assignment"  , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence: 16.6 , evaledRightToLeft: true, isInFixOperator:   true , isAssignmentOperator: true },
    { representation: ">>="                  , name: "bitwise-shift-right-assignment" , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence: 16.6 , evaledRightToLeft: true, isInFixOperator:   true , isAssignmentOperator: true },
    { representation: "<<"                   , name: "bitwise-shift-left"             , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence:  7   , evaledLeftToRight: true, isInFixOperator:   true },
    { representation: ">>"                   , name: "bitwise-shift-right"            , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence:  7   , evaledLeftToRight: true, isInFixOperator:   true },
    { representation: "<=>"                  , name: "three-way-compare"              , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence:  8   , evaledLeftToRight: true, isInFixOperator:   true , isComparisonOperator: true},
    { representation: "<"                    , name: "less-than"                      , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence:  9.1 , evaledLeftToRight: true, isInFixOperator:   true , isComparisonOperator: true},
    { representation: "<="                   , name: "less-than-or-equal-to"          , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence:  9.1 , evaledLeftToRight: true, isInFixOperator:   true , isComparisonOperator: true},
    { representation: ">"                    , name: "greater-than"                   , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence:  9.2 , evaledLeftToRight: true, isInFixOperator:   true , isComparisonOperator: true},
    { representation: ">="                   , name: "greater-than-or-equal-to"       , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence:  9.2 , evaledLeftToRight: true, isInFixOperator:   true , isComparisonOperator: true},
    { representation: "=="                   , name: "equal-to"                       , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence: 10   , evaledLeftToRight: true, isInFixOperator:   true , isComparisonOperator: true},
    { representation: "!="                   , name: "not-equal-to"                   , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence: 10   , evaledLeftToRight: true, isInFixOperator:   true , isComparisonOperator: true},
    { representation: "not_eq"               , name: "not-equal-to-word"              , isOperator: true,                                      isBinaryOperator:  true, presedence: 10   , evaledLeftToRight: true, isInFixOperator:   true , isComparisonOperator: true, isOperatorAlias: true,},
    { representation: "&"                    , name: "bitwise-and"                    , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence: 11   , evaledLeftToRight: true, isInFixOperator:   true },
    { representation: "bitand"               , name: "bitwise-and-word"               , isOperator: true,                                      isBinaryOperator:  true, presedence: 11   , evaledLeftToRight: true, isInFixOperator:   true , isOperatorAlias: true},
    { representation: "^"                    , name: "bitwise-xor"                    , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence: 12   , evaledLeftToRight: true, isInFixOperator:   true },
    { representation: "xor"                  , name: "bitwise-xor-word"               , isOperator: true,                                      isBinaryOperator:  true, presedence: 12   , evaledLeftToRight: true, isInFixOperator:   true , isOperatorAlias: true},
    { representation: "|"                    , name: "bitwise-or"                     , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence: 13   , evaledLeftToRight: true, isInFixOperator:   true },
    { representation: "bitor"                , name: "bitwise-or-word"                , isOperator: true,                                      isBinaryOperator:  true, presedence: 12   , evaledLeftToRight: true, isInFixOperator:   true , isOperatorAlias: true},
    { representation: "&&"                   , name: "logical-and"                    , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence: 14   , evaledLeftToRight: true, isInFixOperator:   true , isLogicicalOperator: true},
    { representation: "and"                  , name: "logical-and-word"               , isOperator: true,                                      isBinaryOperator:  true, presedence: 14   , evaledLeftToRight: true, isInFixOperator:   true , isLogicicalOperator: true, isOperatorAlias: true},
    { representation: "||"                   , name: "logical-or"                     , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence: 15   , evaledLeftToRight: true, isInFixOperator:   true , isLogicicalOperator: true},
    { representation: "or"                   , name: "logical-or-word"                , isOperator: true,                                      isBinaryOperator:  true, presedence: 15   , evaledLeftToRight: true, isInFixOperator:   true , isLogicicalOperator: true, isOperatorAlias: true},
    { representation: "?:"                   , name: "ternary-conditional"            , isOperator: true,                                      isTernaryOperator: true, presedence: 16.1 , evaledRightToLeft: true,                         },
    { representation: "throw"                , name: "throw"                          , isOperator: true,                                      isUrnaryOperator:  true, presedence: 16.2 , evaledRightToLeft: true, isPreFixOperator:  true , isControlFlow: true, isExceptionRelated: true},
    { representation: "="                    , name: "direct-assignment"              , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence: 16.3 , evaledRightToLeft: true, isInFixOperator:   true , isAssignmentOperator: true },
    { representation: "+="                   , name: "addition-assignment"            , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence: 16.4 , evaledRightToLeft: true, isInFixOperator:   true , isAssignmentOperator: true },
    { representation: "-="                   , name: "subtraction-assignment"         , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence: 16.4 , evaledRightToLeft: true, isInFixOperator:   true , isAssignmentOperator: true },
    { representation: "*="                   , name: "multiplication-assignment"      , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence: 16.5 , evaledRightToLeft: true, isInFixOperator:   true , isAssignmentOperator: true },
    { representation: "/="                   , name: "division-assignment"            , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence: 16.5 , evaledRightToLeft: true, isInFixOperator:   true , isAssignmentOperator: true },
    { representation: "%="                   , name: "modulus-assignment"             , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence: 16.5 , evaledRightToLeft: true, isInFixOperator:   true , isAssignmentOperator: true },
    { representation: "&="                   , name: "bitwise-and-assignment"         , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence: 16.7 , evaledRightToLeft: true, isInFixOperator:   true , isAssignmentOperator: true },
    { representation: "and_eq"               , name: "bitwise-and-assignment-word"    , isOperator: true,                                      isBinaryOperator:  true, presedence: 16.7 , evaledRightToLeft: true, isInFixOperator:   true , isAssignmentOperator: true , isOperatorAlias: true},
    { representation: "^="                   , name: "bitwise-xor-assignment"         , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence: 16.7 , evaledRightToLeft: true, isInFixOperator:   true , isAssignmentOperator: true },
    { representation: "xor_eq"               , name: "bitwise-xor-assignment-word"    , isOperator: true,                                      isBinaryOperator:  true, presedence: 16.7 , evaledRightToLeft: true, isInFixOperator:   true , isAssignmentOperator: true , isOperatorAlias: true},
    { representation: "|="                   , name: "bitwise-or-assignment"          , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence: 16.7 , evaledRightToLeft: true, isInFixOperator:   true , isAssignmentOperator: true },
    { representation: "or_eq"                , name: "bitwise-or-assignment-word"     , isOperator: true,                                      isBinaryOperator:  true, presedence: 16.7 , evaledRightToLeft: true, isInFixOperator:   true , isAssignmentOperator: true , isOperatorAlias: true},
    { representation: ","                    , name: "comma"                          , isOperator: true, canAppearAfterOperatorKeyword: true, isBinaryOperator:  true, presedence: 16.7 , evaledRightToLeft: true, isInFixOperator:   true },
    # no presedence
    { representation: "alignof"              , name: "alignof"                        , isOperator: true,                                                                                                           isFunctionLike:  true },
    { representation: "alignas"              , name: "alignas"                        , isOperator: true,                                                                                                           isFunctionLike:  true },
    { representation: "typeid"               , name: "typeid"                         , isOperator: true,                                                                                                           isFunctionLike:  true },
    { representation: "noexcept"             , name: "noexcept"                       , isOperator: true },
    { representation: "noexcept"             , name: "noexcept"                       , isOperator: true,  isFunctionLike: true },
    { representation: "static_cast"          , name: "static_cast"                    , isOperator: true , isTypeCastingOperator: true},
    { representation: "dynamic_cast"         , name: "dynamic_cast"                   , isOperator: true , isTypeCastingOperator: true},
    { representation: "const_cast"           , name: "const_cast"                     , isOperator: true , isTypeCastingOperator: true},
    { representation: "reinterpret_cast"     , name: "reinterpret_cast"               , isOperator: true , isTypeCastingOperator: true},
    # control
    { representation: "while"                , name: "while"                          , isControlFlow: true, requiresParentheseBlockImmediately: true, },
    { representation: "for"                  , name: "for"                            , isControlFlow: true, requiresParentheseBlockImmediately: true, },
    { representation: "do"                   , name: "do"                             , isControlFlow: true,                                           },
    { representation: "if"                   , name: "if"                             , isControlFlow: true, requiresParentheseBlockImmediately: true, },
    { representation: "else"                 , name: "else"                           , isControlFlow: true,                                           },
    { representation: "goto"                 , name: "goto"                           , isControlFlow: true,                                           },
    { representation: "switch"               , name: "switch"                         , isControlFlow: true, requiresParentheseBlockImmediately: true, },
    { representation: "try"                  , name: "try"                            , isControlFlow: true,                                           isExceptionRelated: true},
    { representation: "catch"                , name: "catch"                          , isControlFlow: true, requiresParentheseBlockImmediately: true, isExceptionRelated: true},
    { representation: "return"               , name: "return"                         , isControlFlow: true,                                           canAppearBeforeLambdaCapture: true },
    { representation: "break"                , name: "break"                          , isControlFlow: true,                                           },
    { representation: "case"                 , name: "case"                           , isControlFlow: true,                                           },
    { representation: "continue"             , name: "continue"                       , isControlFlow: true,                                           },
    { representation: "default"              , name: "default"                        , isControlFlow: true,                                           },
    { representation: "co_await"             , name: "co_await"                       , isControlFlow: true,                                           },
    { representation: "co_yield"             , name: "co_yield"                       , isControlFlow: true,                                           },
    { representation: "co_return"            , name: "co_return"                      , isControlFlow: true,                                           },
    # primitive type keywords
    # https://en.cppreference.com/w/cpp/language/types
    { representation: "auto"                 , name: "auto"                           , isPrimitive: true, isType: true},
    { representation: "void"                 , name: "void"                           , isPrimitive: true, isType: true},
    { representation: "char"                 , name: "char"                           , isPrimitive: true, isType: true},
    { representation: "short"                , name: "short"                          , isPrimitive: true, isType: true, isTypeSpecifier: true},
    { representation: "int"                  , name: "int"                            , isPrimitive: true, isType: true},
    { representation: "signed"               , name: "signed"                         , isPrimitive: true, isType: true, isTypeSpecifier: true},
    { representation: "unsigned"             , name: "unsigned"                       , isPrimitive: true, isType: true, isTypeSpecifier: true},
    { representation: "long"                 , name: "long"                           , isPrimitive: true, isType: true, isTypeSpecifier: true},
    { representation: "float"                , name: "float"                          , isPrimitive: true, isType: true},
    { representation: "double"               , name: "double"                         , isPrimitive: true, isType: true},
    { representation: "bool"                 , name: "bool"                           , isPrimitive: true, isType: true},
    { representation: "wchar_t"              , name: "wchar_t"                        , isPrimitive: true, isType: true},
    # other types
    { representation: "u_char"               , name: "u_char"               , isType: true },
    { representation: "u_short"              , name: "u_short"              , isType: true },
    { representation: "u_int"                , name: "u_int"                , isType: true },
    { representation: "u_long"               , name: "u_long"               , isType: true },
    { representation: "ushort"               , name: "ushort"               , isType: true },
    { representation: "uint"                 , name: "uint"                 , isType: true },
    { representation: "u_quad_t"             , name: "u_quad_t"             , isType: true },
    { representation: "quad_t"               , name: "quad_t"               , isType: true },
    { representation: "qaddr_t"              , name: "qaddr_t"              , isType: true },
    { representation: "caddr_t"              , name: "caddr_t"              , isType: true },
    { representation: "daddr_t"              , name: "daddr_t"              , isType: true },
    { representation: "div_t"                , name: "div_t"                , isType: true },
    { representation: "dev_t"                , name: "dev_t"                , isType: true },
    { representation: "fixpt_t"              , name: "fixpt_t"              , isType: true },
    { representation: "blkcnt_t"             , name: "blkcnt_t"             , isType: true },
    { representation: "blksize_t"            , name: "blksize_t"            , isType: true },
    { representation: "gid_t"                , name: "gid_t"                , isType: true },
    { representation: "in_addr_t"            , name: "in_addr_t"            , isType: true },
    { representation: "in_port_t"            , name: "in_port_t"            , isType: true },
    { representation: "ino_t"                , name: "ino_t"                , isType: true },
    { representation: "key_t"                , name: "key_t"                , isType: true },
    { representation: "mode_t"               , name: "mode_t"               , isType: true },
    { representation: "nlink_t"              , name: "nlink_t"              , isType: true },
    { representation: "id_t"                 , name: "id_t"                 , isType: true },
    { representation: "pid_t"                , name: "pid_t"                , isType: true },
    { representation: "off_t"                , name: "off_t"                , isType: true },
    { representation: "segsz_t"              , name: "segsz_t"              , isType: true },
    { representation: "swblk_t"              , name: "swblk_t"              , isType: true },
    { representation: "uid_t"                , name: "uid_t"                , isType: true },
    { representation: "id_t"                 , name: "id_t"                 , isType: true },
    { representation: "clock_t"              , name: "clock_t"              , isType: true },
    { representation: "size_t"               , name: "size_t"               , isType: true },
    { representation: "ssize_t"              , name: "ssize_t"              , isType: true },
    { representation: "time_t"               , name: "time_t"               , isType: true },
    { representation: "useconds_t"           , name: "useconds_t"           , isType: true },
    { representation: "suseconds_t"          , name: "suseconds_t"          , isType: true },
    { representation: "int8_t"               , name: "int8_t"               , isType: true },
    { representation: "int16_t"              , name: "int16_t"              , isType: true },
    { representation: "int32_t"              , name: "int32_t"              , isType: true },
    { representation: "int64_t"              , name: "int64_t"              , isType: true },
    { representation: "uint8_t"              , name: "uint8_t"              , isType: true },
    { representation: "uint16_t"             , name: "uint16_t"             , isType: true },
    { representation: "uint32_t"             , name: "uint32_t"             , isType: true },
    { representation: "uint64_t"             , name: "uint64_t"             , isType: true },
    { representation: "int_least8_t"         , name: "int_least8_t"         , isType: true },
    { representation: "int_least16_t"        , name: "int_least16_t"        , isType: true },
    { representation: "int_least32_t"        , name: "int_least32_t"        , isType: true },
    { representation: "int_least64_t"        , name: "int_least64_t"        , isType: true },
    { representation: "uint_least8_t"        , name: "uint_least8_t"        , isType: true },
    { representation: "uint_least16_t"       , name: "uint_least16_t"       , isType: true },
    { representation: "uint_least32_t"       , name: "uint_least32_t"       , isType: true },
    { representation: "uint_least64_t"       , name: "uint_least64_t"       , isType: true },
    { representation: "int_fast8_t"          , name: "int_fast8_t"          , isType: true },
    { representation: "int_fast16_t"         , name: "int_fast16_t"         , isType: true },
    { representation: "int_fast32_t"         , name: "int_fast32_t"         , isType: true },
    { representation: "int_fast64_t"         , name: "int_fast64_t"         , isType: true },
    { representation: "uint_fast8_t"         , name: "uint_fast8_t"         , isType: true },
    { representation: "uint_fast16_t"        , name: "uint_fast16_t"        , isType: true },
    { representation: "uint_fast32_t"        , name: "uint_fast32_t"        , isType: true },
    { representation: "uint_fast64_t"        , name: "uint_fast64_t"        , isType: true },
    { representation: "intptr_t"             , name: "intptr_t"             , isType: true },
    { representation: "uintptr_t"            , name: "uintptr_t"            , isType: true },
    { representation: "intmax_t"             , name: "intmax_t"             , isType: true },
    { representation: "intmax_t"             , name: "intmax_t"             , isType: true },
    { representation: "uintmax_t"            , name: "uintmax_t"            , isType: true },
    { representation: "uintmax_t"            , name: "uintmax_t"            , isType: true },
    { representation: "uintmax_t"            , name: "uintmax_t"            , isType: true },
    # literals
    { representation: "NULL"                 , name: "NULL"             , isLiteral: true },
    { representation: "true"                 , name: "true"             , isLiteral: true },
    { representation: "false"                , name: "false"            , isLiteral: true },
    { representation: "nullptr"              , name: "nullptr"          , isLiteral: true },
    # type creators
    { representation: "class"                , name: "class"           , isTypeCreator: true},
    { representation: "struct"               , name: "struct"          , isTypeCreator: true},
    { representation: "union"                , name: "union"           , isTypeCreator: true},
    { representation: "enum"                 , name: "enum"            , isTypeCreator: true},
    # storage specifiers https://en.cppreference.com/w/cpp/language/declarations 
    { representation: "const"                , name: "const"            , isSpecifier: true, isStorageSpecifier: true },
    { representation: "static"               , name: "static"           , isSpecifier: true, isStorageSpecifier: true },
    { representation: "volatile"             , name: "volatile"         , isSpecifier: true, isStorageSpecifier: true },
    { representation: "register"             , name: "register"         , isSpecifier: true, isStorageSpecifier: true },
    { representation: "restrict"             , name: "restrict"         , isSpecifier: true, isStorageSpecifier: true },
    { representation: "extern"               , name: "extern"           , isSpecifier: true, isStorageSpecifier: true, isClassSpecifier: true },
    # function specifiers/qualifiers
    { representation: "inline"               , name: "inline"           , isSpecifier: true , isFunctionSpecifier: true},
    { representation: "constexpr"            , name: "constexpr"        , isSpecifier: true , isFunctionSpecifier: true},
    { representation: "mutable"              , name: "mutable"          , isSpecifier: true , isFunctionSpecifier: true},
    { representation: "friend"               , name: "friend"           , isSpecifier: true , isFunctionSpecifier: true},
    { representation: "explicit"             , name: "explicit"         , isSpecifier: true , isFunctionSpecifier: true},
    { representation: "virtual"              , name: "virtual"          , isSpecifier: true , isFunctionSpecifier: true, isInheritanceSpecifier: true },
    { representation: "final"                , name: "final"            , functionQualifier: true, canAppearAfterParametersBeforeBody: true , isValidFunctionName: true, isClassInheritenceSpecifier: true},
    { representation: "override"             , name: "override"         , functionQualifier: true, canAppearAfterParametersBeforeBody: true , isValidFunctionName: true, isClassInheritenceSpecifier: true},
    { representation: "volatile"             , name: "volatile"         , functionQualifier: true, canAppearAfterParametersBeforeBody: true },
    { representation: "const"                , name: "const"            , functionQualifier: true, canAppearAfterParametersBeforeBody: true },
    { representation: "noexcept"             , name: "noexcept"         , isSpecifier: true ,      canAppearAfterParametersBeforeBody: true },
    # if statement specifiers see https://en.cppreference.com/w/cpp/language/if
    { representation: "constexpr"            , name: "constexpr"        , isSpecifier: true , isIfStatementSpecifier: true },
    # lambda specifiers
    { representation: "mutable"                , name: "mutable"            , isLambdaSpecifier: true },
    { representation: "constexpr"              , name: "constexpr"          , isLambdaSpecifier: true },
    { representation: "consteval"              , name: "consteval"          , isLambdaSpecifier: true },
    # accessor
    { representation: "private"               , name: "private"             , isAccessSpecifier: true, isInheritanceSpecifier: true },
    { representation: "protected"             , name: "protected"           , isAccessSpecifier: true, isInheritanceSpecifier: true },
    { representation: "public"                , name: "public"              , isAccessSpecifier: true, isInheritanceSpecifier: true },
    # pre processor directives
    { representation: "if"                    , name: "if"                     , isPreprocessorDirective: true },
    { representation: "elif"                  , name: "elif"                   , isPreprocessorDirective: true },
    { representation: "else"                  , name: "else"                   , isPreprocessorDirective: true },
    { representation: "endif"                 , name: "endif"                  , isPreprocessorDirective: true },
    { representation: "ifdef"                 , name: "ifdef"                  , isPreprocessorDirective: true },
    { representation: "ifndef"                , name: "ifndef"                 , isPreprocessorDirective: true },
    { representation: "define"                , name: "define"                 , isPreprocessorDirective: true },
    { representation: "undef"                 , name: "undef"                  , isPreprocessorDirective: true },
    { representation: "include"               , name: "include"                , isPreprocessorDirective: true },
    { representation: "line"                  , name: "line"                   , isPreprocessorDirective: true },
    { representation: "error"                 , name: "error"                  , isPreprocessorDirective: true },
    { representation: "warning"               , name: "warning"                , isPreprocessorDirective: true },
    { representation: "pragma"                , name: "pragma"                 , isPreprocessorDirective: true },
    { representation: "_Pragma"               , name: "pragma"                 , isPreprocessorDirective: true },
    { representation: "defined"               , name: "defined"                , isPreprocessorDirective: true },
    { representation: "__has_include"         , name: "__has_include"          , isPreprocessorDirective: true },
    { representation: "__has_cpp_attribute"   , name: "__has_cpp_attribute"    , isPreprocessorDirective: true },

    # 
    # misc
    # 
    # https://en.cppreference.com/w/cpp/keyword
    { representation: "this"            , name: "this"          },
    { representation: "template"        , name: "template"      },
    { representation: "namespace"       , name: "namespace"     },
    { representation: "using"           , name: "using"         },
    { representation: "operator"        , name: "operator"      },
    # 
    { representation: "typedef"         , name: "typedef"       , isCurrentlyAMiscKeyword: true },
    { representation: "decltype"        , name: "decltype"      , isSpecifier: true,  isFunctionLike: true },
    { representation: "typename"        , name: "typename"      },
    # 
    { representation: "asm"                        , name: "asm"                        },
    { representation: "__asm__"                    , name: "__asm__"                    },
    # 
    { representation: "concept"                    , name: "concept"                    , isCurrentlyAMiscKeyword: true },
    { representation: "requires"                   , name: "requires"                   , isCurrentlyAMiscKeyword: true },
    { representation: "export"                     , name: "export"                     , isCurrentlyAMiscKeyword: true },
    { representation: "thread_local"               , name: "thread_local"               },
    { representation: "atomic_cancel"              , name: "atomic_cancel"              },
    { representation: "atomic_commit"              , name: "atomic_commit"              },
    { representation: "atomic_noexcept"            , name: "atomic_noexcept"            },
    { representation: "co_await"                   , name: "co_await"                   },
    { representation: "co_return"                  , name: "co_return"                  },
    { representation: "co_yield"                   , name: "co_yield"                   },
    { representation: "import"                     , name: "import"                     },
    { representation: "module"                     , name: "module"                     , isCurrentlyAMiscKeyword: true },
    { representation: "reflexpr"                   , name: "reflexpr"                   },
    { representation: "synchronized"               , name: "synchronized"               },
    # 
    { representation: "audit"                      , name: "audit"                      , isSpecialIdentifier: true , isValidFunctionName: true},
    { representation: "axiom"                      , name: "axiom"                      , isSpecialIdentifier: true , isValidFunctionName: true},
    { representation: "transaction_safe"           , name: "transaction_safe"           , isSpecialIdentifier: true , isValidFunctionName: true},
    { representation: "transaction_safe_dynamic"   , name: "transaction_safe_dynamic"   , isSpecialIdentifier: true , isValidFunctionName: true},
]



@cpp_tokens = TokenHelper.new tokens, for_each_token: ->(each) do 
    # isSymbol, isWordish
    if each[:representation] =~ /[a-zA-Z0-9_]/
        each[:isWordish] = true
    else
        each[:isSymbol] = true
    end
    # isWord
    if each[:representation] =~ /\A[a-zA-Z_][a-zA-Z0-9_]*\z/
        each[:isWord] = true
    end
    
    if each[:isTypeSpecifier] or each[:isStorageSpecifier]
        each[:isPossibleStorageSpecifier] = true
    end
end



@cpp_support_tokens = TokenHelper.new [
    # io stream
    { representation: "cin"                        , name: "cin"                        , belongsToIostream: true , isVariable: true},
    { representation: "wcin"                       , name: "wcin"                       , belongsToIostream: true , isVariable: true},
    { representation: "cout"                       , name: "cout"                       , belongsToIostream: true , isVariable: true},
    { representation: "wcout"                      , name: "wcout"                      , belongsToIostream: true , isVariable: true},
    { representation: "cerr"                       , name: "cerr"                       , belongsToIostream: true , isVariable: true},
    { representation: "wcerr"                      , name: "wcerr"                      , belongsToIostream: true , isVariable: true},
    { representation: "clog"                       , name: "clog"                       , belongsToIostream: true , isVariable: true},
    { representation: "wclog"                      , name: "wclog"                      , belongsToIostream: true , isVariable: true},
    # stdio
    { representation: "stderr"                     , name: "stderr"                     , belongsToStdio: true , isVariable: true},
    { representation: "stdin"                      , name: "stdin"                      , belongsToStdio: true , isVariable: true},
    { representation: "stdout"                     , name: "stdout"                     , belongsToStdio: true , isVariable: true},
    { representation: "FILE"                       , name: "FILE"                       , belongsToStdio: true , isType: true},
    { representation: "fpos_t"                     , name: "fpos_t"                     , belongsToStdio: true , isType: true},
    { representation: "size_t"                     , name: "size_t"                     , belongsToStdio: true , isType: true},
    
    # pthread types
    # TODO: I'm not sure if pthread is actually a support type or if it is part of the language spec, I'd assume support
    { representation: "pthread_t"            , name: "pthread_t"            , isType: true , isPthreadType: true },
    { representation: "pthread_attr_t"       , name: "pthread_attr_t"       , isType: true , isPthreadType: true },
    { representation: "pthread_cond_t"       , name: "pthread_cond_t"       , isType: true , isPthreadType: true },
    { representation: "pthread_condattr_t"   , name: "pthread_condattr_t"   , isType: true , isPthreadType: true },
    { representation: "pthread_mutex_t"      , name: "pthread_mutex_t"      , isType: true , isPthreadType: true },
    { representation: "pthread_mutexattr_t"  , name: "pthread_mutexattr_t"  , isType: true , isPthreadType: true },
    { representation: "pthread_once_t"       , name: "pthread_once_t"       , isType: true , isPthreadType: true },
    { representation: "pthread_rwlock_t"     , name: "pthread_rwlock_t"     , isType: true , isPthreadType: true },
    { representation: "pthread_rwlockattr_t" , name: "pthread_rwlockattr_t" , isType: true , isPthreadType: true },
    { representation: "pthread_key_t"        , name: "pthread_key_t"        , isType: true , isPthreadType: true },
]
