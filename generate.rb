
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

all_symbol_operators =  [math_operators, logic_operators, comparision_operators, bitwise_operators, assignment_operators, special_operators].flatten

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





# 
# Helper patterns for contstructing regular expressions
# 
white_space = /\s*/
white_space_boundary = /(?<=\s)(?=\S)/
variable_name = /\b[a-zA-Z_][a-zA-Z_0-9]*\b/
$_variable_name = /\b([a-zA-Z_][a-zA-Z_0-9]*)\b/
$_match_any_number_of_scopes = /((?:\b[A-Za-z_][A-Za-z0-9_]*(?:<[\s<>\w]*?)?::)*)/
any_non_var_declare_type = "\\b(?:#{non_var_declare_type*"|"})\\b"
any_operator = "#{all_symbol_operators.map {|each| Regexp.escape(each) }.join('|')}"
any_modifier_only_word = "\\b(?:#{type_modifier_only_list*"|"})\\b"
any_singlular_type = "\\b(?:#{basic_type_specifiers*"|" + known_types*"|"})\\b"
$__any_fixed_type = /(#{any_modifier_only_word})?#{white_space}((?:#{any_singlular_type}#{white_space})+)/
$_with_reference = /\s*(&|&&)\s*/
$_with_dereference = /\s*(|\**)\s*/
with_ref_and_deref = /\s*(?:&|&&|\**)\s*/
function_cannot_be = /while|for|do|if|else|switch|catch|enumerate|return|typeid|alignof|alignas|sizeof|[cr]?iterate|and|and_eq|bitand|bitor|compl|not|not_eq|or|or_eq|typeid|xor|xor_eq|alignof|alignas/
builtin_c99_function_names = /(_Exit|(?:nearbyint|nextafter|nexttoward|netoward|nan)[fl]?|a(?:cos|sin)h?[fl]?|abort|abs|asctime|assert|atan(?:[h2]?[fl]?)?|atexit|ato[ifl]|atoll|bsearch|btowc|cabs[fl]?|cacos|cacos[fl]|cacosh[fl]?|calloc|carg[fl]?|casinh?[fl]?|catanh?[fl]?|cbrt[fl]?|ccosh?[fl]?|ceil[fl]?|cexp[fl]?|cimag[fl]?|clearerr|clock|clog[fl]?|conj[fl]?|copysign[fl]?|cosh?[fl]?|cpow[fl]?|cproj[fl]?|creal[fl]?|csinh?[fl]?|csqrt[fl]?|ctanh?[fl]?|ctime|difftime|div|erfc?[fl]?|exit|fabs[fl]?|exp(?:2[fl]?|[fl]|m1[fl]?)?|fclose|fdim[fl]?|fe[gs]et(?:env|exceptflag|round)|feclearexcept|feholdexcept|feof|feraiseexcept|ferror|fetestexcept|feupdateenv|fflush|fgetpos|fgetw?[sc]|floor[fl]?|fmax?[fl]?|fmin[fl]?|fmod[fl]?|fopen|fpclassify|fprintf|fputw?[sc]|fread|free|freopen|frexp[fl]?|fscanf|fseek|fsetpos|ftell|fwide|fwprintf|fwrite|fwscanf|genv|get[sc]|getchar|gmtime|gwc|gwchar|hypot[fl]?|ilogb[fl]?|imaxabs|imaxdiv|isalnum|isalpha|isblank|iscntrl|isdigit|isfinite|isgraph|isgreater|isgreaterequal|isinf|isless(?:equal|greater)?|isw?lower|isnan|isnormal|isw?print|isw?punct|isw?space|isunordered|isw?upper|iswalnum|iswalpha|iswblank|iswcntrl|iswctype|iswdigit|iswgraph|isw?xdigit|labs|ldexp[fl]?|ldiv|lgamma[fl]?|llabs|lldiv|llrint[fl]?|llround[fl]?|localeconv|localtime|log[2b]?[fl]?|log1[p0][fl]?|longjmp|lrint[fl]?|lround[fl]?|malloc|mbr?len|mbr?towc|mbsinit|mbsrtowcs|mbstowcs|memchr|memcmp|memcpy|memmove|memset|mktime|modf[fl]?|perror|pow[fl]?|printf|puts|putw?c(?:har)?|qsort|raise|rand|remainder[fl]?|realloc|remove|remquo[fl]?|rename|rewind|rint[fl]?|round[fl]?|scalbl?n[fl]?|scanf|setbuf|setjmp|setlocale|setvbuf|signal|signbit|sinh?[fl]?|snprintf|sprintf|sqrt[fl]?|srand|sscanf|strcat|strchr|strcmp|strcoll|strcpy|strcspn|strerror|strftime|strlen|strncat|strncmp|strncpy|strpbrk|strrchr|strspn|strstr|strto[kdf]|strtoimax|strtol[dl]?|strtoull?|strtoumax|strxfrm|swprintf|swscanf|system|tan|tan[fl]|tanh[fl]?|tgamma[fl]?|time|tmpfile|tmpnam|tolower|toupper|trunc[fl]?|ungetw?c|va_arg|va_copy|va_end|va_start|vfw?printf|vfw?scanf|vprintf|vscanf|vsnprintf|vsprintf|vsscanf|vswprintf|vswscanf|vwprintf|vwscanf|wcrtomb|wcscat|wcschr|wcscmp|wcscoll|wcscpy|wcscspn|wcsftime|wcslen|wcsncat|wcsncmp|wcsncpy|wcspbrk|wcsrchr|wcsrtombs|wcsspn|wcsstr|wcsto[dkf]|wcstoimax|wcstol[dl]?|wcstombs|wcstoull?|wcstoumax|wcsxfrm|wctom?b|wmem(?:set|chr|cpy|cmp|move)|wprintf|wscanf)/
possible_type_endings = /[&*>a-zA-Z0-9_\]\)]/
preceding_object = /([a-zA-Z_][a-zA-Z_0-9]*|(?<=[\]\)]))/
control_statements_with_paraentheses = /if|for|while|switch|catch/


# had to do this one manually because the readable/english way was timing out durning runtime (in the editor)
$__probably_a_parameter = /(?-mix:([a-zA-Z_][a-zA-Z_0-9]*)\s*(?==)|(?:(?<=[a-zA-Z0-9_])\s+|(?<=[&*>\]\)])\s*)([a-zA-Z_][a-zA-Z_0-9]*)\s*(?=(?:\[\]|)(,|\))))/

# Output the regex in a form for the .json file
p $__probably_a_parameter.to_s
