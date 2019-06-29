source_dir = "../../"
require_relative source_dir + 'textmate_tools.rb'
require_relative source_dir + 'repo_specific_helpers.rb'
require_relative source_dir + 'shared_patterns/source_wrapper.rb'
require_relative './tokens.rb'
require 'json'

# go to where this file is located
Dir.chdir __dir__

# 
# Setup grammar
# 
    original_grammar = JSON.parse(IO.read("original.tmlanguage.json"))
    Grammar.convertSpecificIncludes(json_grammar: original_grammar, convert:["$self", "$base"], into: "#root_context")
    grammar = Grammar.new(
        name: original_grammar["name"],
        scope_name: original_grammar["scopeName"],
        version: "",
        information_for_contributors: [
            "This code was auto generated by a much-more-readble ruby file",
            "see https://github.com/jeff-hykin/cpp-textmate-grammar/blob/master",
        ],
    )

#
#
# Contexts
#
#
    grammar[:$initial_context] = source_wrapper()
    grammar[:root_context] = [
            # import all the original patterns
            *original_grammar["patterns"],
        ]
#
#
# Patterns
#
#
    # copy over all the repos
    for each_key, each_value in original_grammar["repository"]
        grammar[each_key.to_sym] = each_value
    end
 
# Save
@syntax_location = saveGrammar(grammar)