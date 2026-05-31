void test() {
    const char* a = "hello \u{41} world";
    const char* b = "emoji \u{1F600}";
    const char* c = "\u{0A} newline escape";
    const char* d = "\N{LATIN SMALL LETTER A}";
    const char* e = "\N{DIGIT ZERO}";
    const char* f = "value: \N{PLUS SIGN}";
    const char* g = "\u0041";
    const char* h = "\U00000041";
}
