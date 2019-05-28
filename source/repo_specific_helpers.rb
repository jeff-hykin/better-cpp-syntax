def saveGrammar(grammar)
    syntax_location = __dir__+"/../syntaxes/#{grammar.language_ending}.tmLanguage"
    grammar.saveAsYamlTo(syntax_location)
    grammar.saveAsJsonTo(syntax_location)
    grammar.saveTagsTo(__dir__+"/../language_tags/#{grammar.language_ending}.txt")
    return syntax_location
end