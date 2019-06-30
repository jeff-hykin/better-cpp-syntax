require 'pathname'

def saveGrammar(grammar)
    root_dir = __dir__+"/../"
    # paths relative to the project root
    package_json_location = root_dir + "./package.json"
    syntax_location       = root_dir + "./syntaxes/#{grammar.language_ending}.tmLanguage"
    language_tag_location = root_dir + "./language_tags/#{grammar.language_ending}.txt"
    # 
    # save the syntax.json, the syntax.yaml, and the tags
    # 
    # the easy (inefficient way) is to do:
    #   grammar.saveAsYamlTo(syntax_location)
    #   grammar.saveAsJsonTo(syntax_location)
    #   grammar.saveTagsTo(language_tag_location)
    # its inefficient because it rebuilds the grammar each time
    
    grammar_as_hash = grammar.to_h
    IO.write(syntax_location+".json", JSON.pretty_generate(grammar_as_hash))
    IO.write(syntax_location+".yaml", grammar_as_hash.to_yaml)
    IO.write(language_tag_location, grammar.all_tags.to_a.sort.join("\n"))
    
    # 
    # add to the package.json, if the language is not already in there
    # 
    # TODO: this should probably be made generic and packaged up inside the textmate_tools.rb as a "addToVsCodePackageJson"
    package_info = JSON.parse(IO.read(package_json_location))
    languages = package_info["contributes"]["grammars"]
    # remove all the languages that are not the current language
    matching_langs = languages.select do |each|
        each["scopeName"] == grammar.data[:scopeName]
    end
    # if not in the package.json
    if matching_langs.length == 0
        # add it to the package.json
        package_info["contributes"]["grammars"].push({
            language: grammar.data[:name].to_s,
            scopeName: grammar.data[:scopeName],
            path: Pathname.new(syntax_location+".json").relative_path_from(Pathname.new(root_dir)),
        })
        # save it as pretty json
        IO.write(package_json_location, JSON.pretty_generate(package_info))
    end
    
    return syntax_location
end