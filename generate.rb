
math_operators = [
    "+",
    "-",
    "*",
    "/",
    "%",
    "++",
    "--",
]
logic_operators = [
    "&&",
    "||",
    "!",
]

comparision_operators = [
    "==",
    "!=",
    "<",
    "<=",
    ">" ,
    ">= ",
]

bitwise_operators = [
    "&",
    "|",
    "^",
    "~",
    "<<",
    ">>",
]
assignment_operators = [
    "=",
    "+=",
    "-=",
    "*=",
    "/=",
    "%=",
    "<<=",
    ">>=",
    "&=",
    "^=",
    "|=",
]
special_operators = [
    ",",
    ".",
    "->",
    "[]",
    "()",
    "?:",
]
word_operators = [
    "sizeof",
    # INCOMEPLETE
]



non_var_declare_type = [
    "friend",
    "explicit",
    "virtual",
    "override",
    "final",
    "noexcept",
    "private",
    "protected",
    "public",
    "catch",
    "try",
    "throw",
    "using",
    "delete",
    "this",
    "nullptr",
    "const_cast",
    "dynamic_cast",
    "reinterpret_cast",
    "static_cast",
    "and",
    "and_eq",
    "bitand",
    "bitor",
    "compl",
    "not",
    "not_eq",
    "or",
    "or_eq",
    "typeid",
    "xor",
    "xor_eq",
    "alignof",
    "alignas",
    "class",
    "decltype",
    "wchar_t",
    "char16_t",
    "char32_t",
    "export",
    "mutable",
    "typename",
    "break",
    "case",
    "continue",
    "default",
    "do",
    "else",
    "for",
    "goto",
    "if",
    "_Pragma",
    "return",
    "switch",
    "while",
    "NULL",
    "true",
    "false",
    "TRUE",
    "FALSE",
    "error",
    "warning",
    "enumerate",
    "return",
    "typeid",
    "alignof",
    "alignas",
    "sizeof",
    "asm",
    "__asm__",
    "struct",
    "union",
    "iterate",
    "riterate",
    "citerate",
]
basic_type_specifiers = [
    "auto",
    "void",
    "char",
    "short",
    "int",
    "signed",
    "unsigned",
    "long",
    "float",
    "double",
    "bool",
    "wchar_t",
]
known_types = [
    "u_char",
    "u_short",
    "u_int",
    "u_long",
    "ushort",
    "uint",
    "u_quad_t",
    "quad_t",
    "qaddr_t",
    "caddr_t",
    "daddr_t",
    "div_t",
    "dev_t",
    "fixpt_t",
    "blkcnt_t",
    "blksize_t",
    "gid_t",
    "in_addr_t",
    "in_port_t",
    "ino_t",
    "key_t",
    "mode_t",
    "nlink_t",
    "id_t",
    "pid_t",
    "off_t",
    "segsz_t",
    "swblk_t",
    "uid_t",
    "id_t",
    "clock_t",
    "size_t",
    "ssize_t",
    "time_t",
    "useconds_t",
    "suseconds_t",
    "pthread_attr_t",
    "pthread_cond_t",
    "pthread_condattr_t",
    "pthread_mutex_t",
    "pthread_mutexattr_t",
    "pthread_once_t",
    "pthread_rwlock_t",
    "pthread_rwlockattr_t",
    "pthread_t",
    "pthread_key_t",
    "int8_t",
    "int16_t",
    "int32_t",
    "int64_t",
    "uint8_t",
    "uint16_t",
    "uint32_t",
    "uint64_t",
    "int_least8_t",
    "int_least16_t",
    "int_least32_t",
    "int_least64_t",
    "uint_least8_t",
    "uint_least16_t",
    "uint_least32_t",
    "uint_least64_t",
    "int_fast8_t",
    "int_fast16_t",
    "int_fast32_t",
    "int_fast64_t",
    "uint_fast8_t",
    "uint_fast16_t",
    "uint_fast32_t",
    "uint_fast64_t",
    "intptr_t",
    "uintptr_t",
    "intmax_t",
    "intmax_t",
    "uintmax_t",
    "uintmax_t",
]

type_modifier_only_list = [
    "constexpr",
    "const",
    "extern",
    "register",
    "restrict",
    "static",
    "volatile",
    "inline",
]

class Regexp
    def or(other_regex)
        return /#{self}|#{other_regex}/
    end
    def and(other_regex)
        return /#{self}#{other_regex}/
    end
    def then(other_regex)
        return /#{self}#{other_regex}/
    end
end


def boundaryDoesNotStartWith(regex)
    return /\b(?!#{regex})/
end







white_space = /\s*/
white_space_boundary = /(?<=\s)(?=\S)/
variable_name = /\b[a-zA-Z_][a-zA-Z_0-9]*\b/
$_variable_name = /\b([a-zA-Z_][a-zA-Z_0-9]*)\b/
$_match_any_number_of_scopes = /((?:\b[A-Za-z_][A-Za-z0-9_]*\b::)*)/
any_non_var_declare_type = "\\b(?:#{non_var_declare_type*"|"})\\b"
any_modifier_only_word = "\\b(?:#{type_modifier_only_list*"|"})\\b"
any_singlular_type = "\\b(?:#{basic_type_specifiers*"|" + known_types*"|"})\\b"
$__any_fixed_type = /(#{any_modifier_only_word})?#{white_space}((?:#{any_singlular_type}#{white_space})+)/
$_with_reference = /\s*(&|&&)\s*/
$_with_dereference = /\s*(|\**)\s*/
with_ref_and_deref = /\s*(?:&|&&|\**)\s*/
function_cannot_be = /while|for|do|if|else|switch|catch|enumerate|return|typeid|alignof|alignas|sizeof|[cr]?iterate|and|and_eq|bitand|bitor|compl|not|not_eq|or|or_eq|typeid|xor|xor_eq|alignof|alignas/

possible_type_endings = /[&*>a-zA-Z0-9_\]\)]/

# problems:
    # no diff between function call and function definition
    # meta.initialization.c matches things it shouldnt (function calls)

# edgecase decltype
# edgecase function pointers
# edgecase literal static arrays ex: char[]

# template
# repeated types


$__probably_a_type = boundaryDoesNotStartWith(any_non_var_declare_type).and($_match_any_number_of_scopes).then($_variable_name)


$__probably_a_parameter = $_variable_name.and(white_space).and(/(?==)/).or(  
    /(?<=#{possible_type_endings})/.and(white_space)
    .and($_variable_name).and(white_space).and(/(?=,|\))/)
)

$__probably_a_parameter = /([a-zA-Z_][a-zA-Z_0-9]*)\s*(?==)|(?<=[&*>a-zA-Z0-9_\]\)])\s+([a-zA-Z_][a-zA-Z_0-9]*)\s*(?=,|\))/

p $__probably_a_parameter.to_s

