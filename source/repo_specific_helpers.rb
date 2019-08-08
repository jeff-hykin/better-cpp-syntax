require_relative '../directory.rb'

def saveGrammar(grammar)
    # 
    # save the syntax.json, the syntax.yaml, and the tags
    # 
    # the easy (inefficient way) is to do:
    #   grammar.saveAsYamlTo(syntax_location)
    #   grammar.saveAsJsonTo(syntax_location)
    #   grammar.saveTagsTo(language_tag_location)
    # its inefficient because it rebuilds the grammar each time
    
    grammar_as_hash = grammar.to_h(inherit_or_embedded: :embedded)
    IO.write(PathFor[:jsonSyntax ][grammar.language_ending], JSON.pretty_generate(grammar_as_hash))
    IO.write(PathFor[:yamlSyntax ][grammar.language_ending], grammar_as_hash.to_yaml)
    IO.write(PathFor[:languageTag][grammar.language_ending], grammar.all_tags.to_a.sort.join("\n"))
    
    # 
    # add to the package.json, if the language is not already in there
    # 
    # TODO: this should probably be made generic and packaged up inside the textmate_tools.rb as a "addToVsCodePackageJson"
    package_info = JSON.parse(IO.read(PathFor[:package_json]))
    languages = package_info["contributes"]["grammars"]
    # remove all the languages that are not the current language
    matching_langs = languages.select do |each|
        each["scopeName"] == grammar.data[:scopeName]
    end
    # if not in the package.json
    if matching_langs.length == 0
        # add it to the package.json
        package_info["contributes"]["grammars"].push({
            language: grammar.data[:name].to_s.downcase,
            scopeName: grammar.data[:scopeName],
            path: Pathname.new(PathFor[:jsonSyntax][grammar.language_ending]).relative_path_from(Pathname.new(PathFor[:root])),
        })
        # save it as pretty json
        IO.write(PathFor[:package_json], JSON.pretty_generate(package_info))
    end
end