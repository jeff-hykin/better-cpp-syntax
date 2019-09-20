require 'textmate_grammar'

cpp_grammar = Grammar.new(
    name: "C++",
    scope_name: "source.cpp",
)

cpp_grammar.import(File.join(__dir__, "source", "languages", "cpp", "lib", "std_space"))
cpp_grammar.import(File.join(__dir__, "source", "languages", "cpp", "lib", "inline_comment"))
cpp_grammar.import(File.join(__dir__, "source", "languages", "cpp", "lib", "preprocessor"))

std_space = cpp_grammar[:std_space]

cpp_grammar[:identifier] = /\w+/

cpp_grammar[:extern_linkage_specifier] = Pattern.new(
    match: std_space.then(
        match: /extern/,
        tag_as: "storage.type.extern"
    ).then(std_space).maybe(
        # This doesn't match the spec as the spec says any string literal is
        # allowed in a linkage specification. However, the spec also says that
        # linkage specification strings should match the name that is being linked.
        # It is unlikely that a language would have a double quote or newline
        # in its name.
        match: Pattern.new(
            match: /\"/,
            tag_as: "punctuation.definition.string.begin"
        ).then(
            match: zeroOrMoreOf(/[^\"]/),
            reference: "linkage"
        ).then(
            match: /\"/,
            tag_as: "punctuation.definition.string.end"
        ),
        tag_as: "string.quoted.double.extern"
    ),
    tag_as: "meta.specifier.linkage.$reference(linkage)"
)

cpp_grammar.save_to(
    dir: "."
)