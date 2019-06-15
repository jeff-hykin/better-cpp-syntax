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
    grammar.saveAsYamlTo(syntax_location)
    grammar.saveAsJsonTo(syntax_location)
    grammar.saveTagsTo(language_tag_location)
    
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
            language: grammar.data[:name].to_s.downcase,
            scopeName: grammar.data[:scopeName],
            path: Pathname.new(syntax_location+".json").relative_path_from(Pathname.new(root_dir)),
        })
        # save it as pretty json
        IO.write(package_json_location, JSON.pretty_generate(package_info))
    end
    
    return syntax_location
end


# 
# Recursive value setting
# 
# TODO: these names/methods should probably be formalized and then put inside their own ruby gem
# TODO: methods should probably be added for other containers, like sets
# TODO: probably should use blocks instead of a lambda
#     # the hash (or array) you want to change
#     a_hash = {
#         a: nil,
#         b: {
#             c: nil,
#             d: {
#                 e: nil
#             }
#         }
#     }
#     # lets say you want to convert all the nil's into empty arrays []
#     # then you'd do:
#     a_hash.recursively_set_each_value! ->(each_value, each_key) do
#         if each_value == nil
#             # return an empty list
#             []
#         else
#             # return the original
#             each_value
#         end
#     end
#     # this would result in:
#     a_hash = {
#         a: [],
#         b: {
#             c: []
#             d: {
#                 e: []
#             }
#         }
#     }
class Hash
    def recursively_set_each_value!(a_lambda)
        for each_key, each_value in self.clone
            # if this was a tree, then start by exploring the tip of the first root
            # (rather than the base of the tree)
            # if it has a :recursively_set_each_value! method, then call it
            if self[each_key].respond_to?(:recursively_set_each_value!)
                self[each_key].recursively_set_each_value!(a_lambda)
            end
            # then allow manipulation of the value
            self[each_key] = a_lambda[each_value, each_key]
        end
    end
end

class Array
    def recursively_set_each_value!(a_lambda)
        new_values = []
        clone = self.clone
        clone.each_with_index do |each_value, each_key|
            # if it has a :recursively_set_each_value! method, then call it
            if self[each_key].respond_to?(:recursively_set_each_value!)
                self[each_key].recursively_set_each_value!(a_lambda)
            end
            self[each_key] = a_lambda[each_value, each_key]
        end
    end
end

# TODO: make this part of the grammar
def convertBaseAndSelf!(from_json_tm_lang:nil, into:nil)
   from_json_tm_lang.recursively_set_each_value! ->(each_value, each_key) do
        if each_key.to_s == "include" && (each_value == "$self" || each_value == "$base")
            into
        else
            each_value
        end
    end 
end
