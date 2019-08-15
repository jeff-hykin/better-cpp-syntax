require 'json'
require 'yaml'
require 'set'
require 'deep_clone' # gem install deep_clone
require 'pathname'

# TODO
    # use the turnOffNumberedCaptureGroups to disable manual regex groups (which otherwise would completely break the group attributes)
        # add a warning whenever turnOffNumberedCaptureGroups successfully removes a group
    # add a check for newlines inside of regex, and warn the user that newlines will never match
    # add feature inside of oneOrMoreOf() or zeroOrMoreOf()
        # using the tag_as: typically breaks because of repeat
        # so instead, if there is a tag_as:, create an includes section on it that copies the original regex pattern and then tags it
    # add a check that doesnt allow $ in non-special repository names
    # have grammar check at the end to make sure that all of the included repository_names are actually valid repo names
    # add method to append something to all tag names (add an extension: "blah" argument to "to_tag")
    # auto generate a repository entry when a pattern/range is used in more than one place
    # create a way to easily mutate anything on an existing pattern
    # add optimizations
        # add check for seeing if the last pattern was an OR with no attributes. if it was then change (a|(b|c)) to (a|b|c)
        # add a "is alreadly a group" flag to prevent double wrapping
def checkForMatchingOuter(str, start_char, end_char)
    # must start and end with correct chars
    if str.length > 2 && str[0] == start_char && str[-1] == end_char
        # remove the first and last character
        str = str.chars
        str.shift()
        str.pop()
        
        depth = 0
        for each in str
            # for every open brace, 1 closed brace is allowed
            if each == start_char
                depth += 1
            elsif each == end_char
                depth -= 1
            end
            # if theres a closed brace before an open brace, then the outer ones dont match
            if depth == -1
                return false
            end
        end
        return true 
    end
    return false
end

# taken from https://gist.github.com/moertel/11091573
# Temporarily redirects STDOUT and STDERR to /dev/null
# but does print exceptions should there occur any.
# Call as:
#   suppress_output { puts 'never printed' }
#
def suppress_output
    begin
        original_stderr = $stderr.clone
        original_stdout = $stdout.clone
        $stderr.reopen(File.new('/dev/null', 'w'))
        $stdout.reopen(File.new('/dev/null', 'w'))
        retval = yield
    rescue Exception => e
        $stdout.reopen(original_stdout)
        $stderr.reopen(original_stderr)
        raise e
    ensure
        $stdout.reopen(original_stdout)
        $stderr.reopen(original_stderr)
    end
    retval
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



class Grammar
    attr_accessor :data, :all_tags, :language_ending, :namespace, :export_options
    
    # 
    # import and export methods
    # 
    @@export_data
    def self.export(*args, &block)
        # this method's goal is to safely namespace external patterns
        # usage: 
        #     Grammar.export(insert_namespace_infront_of_new_grammar_repos: true, insert_namespace_infront_of_all_included_repos: true) do |grammar, namespace|
        #         # create patterns here with the grammar object
        #     end
        # 
        # however there is no perfect way to get this done because of dynamic pattern generation and things like includes
        # because the solution is imperfect, namespacing is opt-in with explicit names of the behavior
        # namely, 
        # - whether or not the grammar[:repo_name] will get namespaced 
        # - and whether or not Pattern(includes:[]) will get namespaced
        # patterns are dynamically namespaced because it is caused by the grammar object they are being given access to
        # this can cause unintuitive results if you are accepting a repo name as an argument for a helper function because that repo name will 
        # get dynamically namespaced. This is designed to be prevented by turning off the insert_namespace_infront_of_all_included_repos: option
        options = {}
        if args.size == 1
            options = args[0]
        end
        # this variable is used to pass data to the instance import() method
        @@export_data = {
            export_options: options,
            lambda: block,
        }
    end
    
    def import(filepath, namespace:"")
        if not Pathname.new(filepath).absolute?
            # try to detect the relative path
            source_directory = File.dirname(caller[0].sub(/:\d+:.+?$/,""))
            # make the filepath absolute
            filepath = File.join(source_directory, filepath)
        end
        # make sure it has the .rb extension, for some reason its required for the load function
        if filepath[-3..-1] != ".rb"
            filepath += ".rb"
        end
        # import the file using load rather than require so that the @@export_data gets reset on each import
        load(filepath)
        # create a shallow copy of the grammar
        namespaced_grammar = Grammar.new(self, namespace, @@export_data[:export_options])
        # add the dot if needed
        if namespace.is_a?(String) && namespace.size > 0
            send_namespace = namespace + '.'
        else
            send_namespace = ''
        end
        if @@export_data != nil
            # run the import function with the namespaced grammar
            output = @@export_data[:lambda][namespaced_grammar, send_namespace]
            # clean up the consumed lambda
            @@export_data = nil
        end
        return output
    end
    
    #
    # Class Methods
    #
    def self.convertTagName(name, group_number, group_attributes, was_first_group_removed: nil)
        new_name = name
        # replace $match with its group number
        new_name.gsub!(/(?<=\$)match/,"#{group_number}" )
        # replace reference() with the group number it was referencing
        new_name.gsub! /(?<=\$)reference\((\w+)\)/ do |match|
            reference = match.match(/(?<=\()\w+/).to_s
            matching_index = group_attributes.find_index { |each| each[:reference] == reference }
            
            if matching_index == nil
                raise "\n\nWhen looking for #{match} I couldnt find any groups with that reference\nThe groups are:\n#{group_attributes.to_yaml}\n\n"
            elsif matching_index !=  group_attributes.size - 1 - group_attributes.reverse.find_index { |each| each[:reference] == reference }
                raise "\n\nWhen looking for #{match} I found multiple groups with that reference\nThe groups are:\n#{group_attributes.to_yaml}\n\n"
            end
            
            if was_first_group_removed
                matching_index -= 1
            end
            # the Nth matching_index is the (N+1)th capture group
            matching_index + 1
        end
        
        return new_name
    end
    # replaces [:backreference:reference] with the groups number it was referencing
    def self.fixupBackRefs(regex_as_string, group_attribute, was_first_group_removed: nil)
        references = Hash.new
        #convert all references to group numbers
        group_attribute.each.with_index { |each, index|
            if each[:reference]
                references[each[:reference]] = index - (was_first_group_removed ? 1 : 0) + 1
            end
        }
        # check for a backref to the Nth group, replace it with `\N` and try again
        regex_as_string.gsub! /\[:backreference:([^\\]+?):\]/ do |match|
            if references[$1] == nil
                raise "When processing the matchResultOf:#{$1}, I couldn't find the group it was referencing"
            end
            # if the reference does exist, then replace it with it's number
            "\\#{references[$1]}"
        end
        # check for a subroutine to the Nth group, replace it with `\N` and try again
        regex_as_string.gsub! /\[:subroutine:([^\\]+?):\]/ do |match|
            if references[$1] == nil
                # this is empty because the subroutine call is often built before the
                # thing it is referencing. 
                # ex:
                # newPattern(
                #     reference: "ref1",
                #     match: newPattern(
                #         /thing/.or(
                #             recursivelyMatch("ref1")
                #         )
                #     )
                # )
                # there's no way easy way to know if this is the case or not
                # so by default nothing is returned so that problems are not caused
                ""
            else
                # if the reference does exist, then replace it with it's number
                "\\g<#{references[$1]}>"
            end
        end
        return regex_as_string
    end
    
    def self.toTag(data, ignore_repository_entry: false)
        # if its a string then include it directly
        if (data.instance_of? String)
            return { include: data }
        # if its a symbol then include a # to make it a repository_name reference
        elsif (data.instance_of? Symbol)
            if data == :$initial_context
                new_value = '$initial_context'
            elsif data == :$base
                new_value = '$base'
            elsif data == :$self
                new_value = '$self'
            else
                new_value = "##{data}"
            end
            return { include: new_value }
        # if its a pattern, then convert it to a tag
        elsif (data.instance_of? Regexp) or (data.instance_of? PatternRange)
            return data.to_tag(ignore_repository_entry: ignore_repository_entry)
        # if its a hash, then just add it as-is
        elsif (data.instance_of? Hash)
            return data
        elsif (data.instance_of? Array)
            return {
                patterns: Grammar.convertIncludesToPatternList(data)
            }
        end
    end
    
    def self.convertRepository(repository)
        if (repository.is_a? Hash) && (repository != {})
            textmate_repository = {}
            for each_key, each_value in repository.each_pair
                textmate_repository[each_key.to_s] = Grammar.toTag(each_value)
            end
            return textmate_repository
        end
    end
    
    def self.convertIncludesToPatternList(includes, ignore_repository_entry: false)
        # Summary:
            # this takes a list, like:
            #     [
            #         # symbol thats the name of a repo
            #         :name_of_thing_in_repo,
            #         # and/or OOP grammar patterns
            #         newPattern(
            #             match: /thing/,
            #             tag_as: 'a.tag.name'
            #         ),
            #         # and/or ranges
            #         PatternRange.new(
            #             start_pattern: /thing/,
            #             end_pattern: /endThing/,
            #             includes: [ :name_of_thing_in_repo ] # <- this list also uses this convertIncludesToPatternList() function
            #         ),
            #         # and/or hashes (hashes need to match the TextMate grammar JSON format)
            #         {
            #             match: /some_regex/,
            #             name: "some.tag.name"
            #         },
            #         # another example of the TextMate grammar format
            #         {
            #             include: '#name_of_thing_in_repo'
            #         }
            #     ]
            # then it converts that list into a TextMate grammar format like this:
            #     [
            #         # symbol conversion
            #         {
            #             include: '#name_of_thing_in_repo'
            #         },
            #         # pattern conversion
            #         {
            #             match: /thing/,
            #             name: 'a.tag.name'
            #         },
            #         # PatternRange conversion
            #         {
            #             begin: /thing/,
            #             end: /thing/,
            #             patterns: [
            #                 {
            #                     include: '#name_of_thing_in_repo'
            #                 }
            #             ]
            #         },
            #         # keeps TextMate hashes the same
            #         {
            #             match: /some_regex/,
            #             name: "some.tag.name"
            #         },
            #         # another example of the TextMate grammar format
            #         {
            #             include: '#name_of_thing_in_repo'
            #         }
            #     ]
        
        # if input=nil then no patterns
        if includes == nil
            return []
        end
        # if input is not Array then error
        if not (includes.instance_of? Array)
            raise "\n\nWhen calling convertIncludesToPatternList() the argument wasn't an array\nThe argument is:#{includes}"
        end
        # create the pattern list
        patterns = []
        for each_include in includes
            patterns.push(Grammar.toTag(each_include, ignore_repository_entry: ignore_repository_entry))
        end
        return patterns
    end
    
    def self.convertSpecificIncludes(json_grammar:nil, convert:[], into:"")
        tags_to_convert = convert.map{|each| each.to_s}
        # iterate over all the keys
        json_grammar.recursively_set_each_value! ->(each_value, each_key) do
            if each_key.to_s == "include"
                # if one of the tags matches
                if tags_to_convert.include?(each_value.to_s)
                    # then replace it with the new value
                    into
                else
                    each_value
                end
            else
                each_value
            end
        end
    end
    
    #
    # Constructor
    #
    def initialize(*args, **kwargs)
        # find out if making a grammar copy or not (for importing)
        if args[0].is_a?(Grammar)
            # make a shallow copy
            @data            = args[0].data
            @language_ending = args[0].language_ending
            if args[1].is_a?(String) && args[1].size > 0
                @namespace = args[1]
            else+
                @namespace = ""
            end
            @export_options  = kwargs
        # if not making a copy then run the normal init
        else
            self.init(*args, **kwargs)
        end
    end
    
    def init(wrap_source: false, name:nil, scope_name:nil, global_patterns:[], repository:{}, file_types:[], **other)
        @data = {
            name: name,
            scopeName: scope_name,
            fileTypes: file_types,
            **other,
            patterns: global_patterns,
            repository: repository,
        }
        @wrap_source     = wrap_source
        @language_ending = scope_name.gsub /.+\.(.+)\z/, "\\1"
        @namespace       = ""
    end
    
    # 
    # internal helpers
    # 
    def insertNamespaceIfNeeded(key)
        if @export_options != nil && @namespace.size > 0 && @export_options[:insert_namespace_infront_of_new_grammar_repos] == true
            return (@namespace + "." + key.to_s).to_sym
        end
        return key
    end
    
    def insertNamespaceToIncludesIfNeeded(pattern)
        if @export_options != nil && @namespace.size > 0 && @export_options[:insert_namespace_infront_of_new_grammar_repos] == true
            if pattern.respond_to?(:includes) && pattern.includes.is_a?(Array)
                # change all the repo names
                index = -1
                for each in pattern.includes.clone
                    index += 1
                    if each.is_a?(Symbol)
                        # change the old value with a new one
                        pattern[index] = (@namespace + "." + each.to_s).to_sym
                    end
                end
            end
        end
    end
    
    #
    # External Helpers
    #
    def [](*args)
        key = args[0]
        key = self.insertNamespaceIfNeeded(key)
        return @data[:repository][key]
    end
    
    def []=(*args)
        # parse out the arguments: grammar[key, (optional_overwrite)] = value
        *keys, value = args
        key, overwrite_option = keys
        key = self.insertNamespaceIfNeeded(key)
        # check for accidental overwrite
        overwrite_allowed = overwrite_option.is_a?(Hash) && overwrite_option[:overwrite]
        if @data[:repository][key] != nil && (not overwrite_option)
            puts "\n\nWarning: the #{key} repository is being overwritten.\n\nIf this is intentional, change:\ngrammar[:#{key}] = *value*\ninto:\ngrammar[:#{key}, overwrite: true] = *value*"
        end
        # add it to the repository
        @data[:repository][key] = value
        # TODO: if the value is an Array, run the insertNamespaceToIncludesIfNeeded 
        # tell the object it was added to a repository
        if (value.instance_of? Regexp) || (value.instance_of? PatternRange)
            value.repository_name = key
            # namespace all of the symbolic includes
            self.insertNamespaceToIncludesIfNeeded(value)
        end
    end
    
    def addToRepository(hash_of_repos)
        @data[:repository].merge!(hash_of_repos)
    end
    
    def convertInitialContextReference(inherit_or_embedded)
        if @wrap_source
            each_pattern[each_key] = '#initial_context'
        elsif inherit_or_embedded == :inherit
            each_pattern[each_key] = "$base"
        elsif inherit_or_embedded == :embedded
            each_pattern[each_key] = "$self"
        else
            raise "\n\nError: the inherit_or_embedded needs to be either :inherit or embedded, but it was #{inherit_or_embedded} instead"
        end
    end
    
    def to_h(inherit_or_embedded: :embedded)
        # 
        # initialize output
        # 
        textmate_output = {
            **@data,
            patterns: [],
            repository: [],
        }
        repository_copy = @data[:repository].dup
        
        # 
        # Convert the :$initial_context into the patterns section
        # 
        initial_context = repository_copy[:$initial_context]
        repository_copy.delete(:$initial_context)
        if @wrap_source
            repository_copy[:initial_context] = initial_context
            # make the actual "initial_context" be the source pattern
            textmate_output[:patterns] = Grammar.convertIncludesToPatternList [
                # this is the source pattern that always gets matched first
                PatternRange.new(
                    zeroLengthStart?: true,
                    # the first position
                    start_pattern: lookAheadFor(/^|\A|\G/),
                    # ensure end never matches
                    # why? because textmate will keep looking until it hits the end of the file (which is the purpose of this wrapper)
                    # how? because the regex is trying to find "not" and then checks to see if "not" == "possible" (which can never happen)
                    end_pattern: /not/.lookBehindFor(/possible/),
                    tag_as: "source",
                    includes: [
                        :initial_context
                    ],
                )
            ]
        else
            textmate_output[:patterns] = Grammar.convertIncludesToPatternList(initial_context)
        end
        for each in initial_context
            if each.is_a? Symbol
                if self[each] == nil
                    raise "\n\nIn :$initial_context there's a \"#{each}\" but \"#{each}\" isn't actually a repo."
                end
            end
        end
        
        #
        # Convert all the repository entries
        #
        for each_name in repository_copy.keys
            repository_copy[each_name] = Grammar.toTag(repository_copy[each_name], ignore_repository_entry: true).dup
        end
        textmate_output[:repository] = repository_copy
        
        # 
        # Add the language endings
        # 
        @all_tags = Set.new()
        # convert all keys into strings
        textmate_output = JSON.parse(textmate_output.to_json)
        language_name = textmate_output["name"] 
        textmate_output.delete("name")
        # convert all the language_endings
        textmate_output.recursively_set_each_value! ->(each_value, each_key) do
            if each_key == "include"
                # 
                # convert the $initial_context
                #
                if each_value == "$initial_context"
                    if @wrap_source
                        '#initial_context'
                    elsif inherit_or_embedded == :inherit
                        "$base"
                    elsif inherit_or_embedded == :embedded
                        "$self"
                    else
                        raise "\n\nError: the inherit_or_embedded needs to be either :inherit or embedded, but it was #{inherit_or_embedded} instead"
                    end
                else
                    each_value
                end
            elsif each_key == "name" || each_key == "contentName"
                #
                # add the language endings
                # 
                new_names = []
                for each_tag in each_value.split(/\s/)
                    each_with_ending = each_tag
                    # if it doesnt already have the ending then add it
                    if not (each_with_ending =~ /#{@language_ending}\z/)
                        each_with_ending += ".#{@language_ending}"
                    end
                    new_names << each_with_ending
                    @all_tags.add(each_with_ending)
                end
                new_names.join(' ')
            else
                each_value
            end
        end
        textmate_output["name"] = language_name
        return textmate_output
    end
    
    def saveAsJsonTo(file_location, inherit_or_embedded: :embedded)
        new_file = File.open(file_location+".json", "w")
        new_file.write(JSON.pretty_generate(self.to_h(inherit_or_embedded: inherit_or_embedded)))
        new_file.close
    end
    
    def saveAsYamlTo(file_location, inherit_or_embedded: :embedded)
        new_file = File.open(file_location+".yaml", "w")
        new_file.write(self.to_h(inherit_or_embedded: inherit_or_embedded).to_yaml)
        new_file.close
    end
    
    def saveTagsTo(file_location)
        self.to_h(inherit_or_embedded: :embedded)
        new_file = File.open(file_location, "w")
        new_file.write(@all_tags.to_a.sort.join("\n"))
        new_file.close
    end
end

#
# extend Regexp to make expressions very readable
#
class Regexp
    attr_accessor :repository_name
    attr_accessor :has_top_level_group
    @@textmate_attributes = {
        name: "",
        match: "",
        patterns: "",
        comment: "",
        tag_as: "",
        includes: "",
        reference: "",
        should_fully_match: "",
        should_not_fully_match: "",
        should_partial_match: "",
        should_not_partial_match: "",
        repository: "",
        word_cannot_be_any_of: "",
        no_warn_match_after_newline?: "",
    }
    
    def __deep_clone__()
        # copy the regex
        self_as_string = self.without_default_mode_modifiers
        new_regex = /#{self_as_string}/
        # copy the attributes
        new_attributes = self.group_attributes.__deep_clone__
        new_regex.group_attributes = new_attributes
        new_regex.has_top_level_group = self.has_top_level_group
        return new_regex
    end
    
    def self.runTest(test_name, arguments, lambda, new_regex)
        if arguments[test_name] != nil
            if not( arguments[test_name].is_a?(Array) )
                raise "\n\nI think there's a #{test_name}: argument, for a newPattern or helper, but the argument isn't an array (and it needs to be to work)\nThe other arguments are #{arguments.to_yaml}"
            end
            failures = []
            for each in arguments[test_name]
                # suppress the regex warnings "nested repeat operator '?' and '+' was replaced with '*' in regular expression"
                suppress_output do
                    if lambda[each]
                        failures.push(each)
                    end
                end
            end
            if failures.size > 0
                puts "\n\nWhen testing the pattern:\nregex: #{new_regex.inspect}\n with these arguments:\n#{arguments.to_yaml}\n\nThe #{test_name} test failed for:\n#{failures.to_yaml}"
            end
        end
    end
    
    #
    # English Helpers
    #
    def lookAheadFor      (other_regex) processRegexLookarounds(other_regex, 'lookAheadFor'     ) end
    def lookAheadToAvoid  (other_regex) processRegexLookarounds(other_regex, 'lookAheadToAvoid' ) end
    def lookBehindFor     (other_regex) processRegexLookarounds(other_regex, 'lookBehindFor'    ) end
    def lookBehindToAvoid (other_regex) processRegexLookarounds(other_regex, 'lookBehindToAvoid') end
    def then         (*arguments) processRegexOperator(arguments, 'then'         ) end
    def or           (*arguments) processRegexOperator(arguments, 'or'           ) end
    def maybe        (*arguments) processRegexOperator(arguments, 'maybe'        ) end
    def oneOrMoreOf  (*arguments) processRegexOperator(arguments, 'oneOrMoreOf'  ) end
    def zeroOrMoreOf (*arguments) processRegexOperator(arguments, 'zeroOrMoreOf' ) end
    def matchResultOf(reference)
        #
        # generate the new regex
        #
        self_as_string = self.without_default_mode_modifiers
        other_regex_as_string = "[:backreference:#{reference}:]"
        new_regex = /#{self_as_string}#{other_regex_as_string}/
        
        #
        # carry over attributes
        #
        new_regex.group_attributes = self.group_attributes
        return new_regex
    end
    def reTag(arguments)
        keep_tags = !(arguments[:all] == false || arguments[:keep] == false) || arguments[:append] != nil
        
        pattern_copy = self.__deep_clone__
        new_attributes = pattern_copy.group_attributes
        
        # this is O(N*M) and could be expensive if reTagging a big pattern
        new_attributes.map!.with_index do |attribute, index|
            # preserves references
            if attribute[:tag_as] == nil
                attribute[:retagged] = true
                next attribute
            end
            arguments.each do |key, tag|
                if key == attribute[:tag_as] or key == attribute[:reference] or key == (index + 1).to_s
                    attribute[:tag_as] = tag
                    attribute[:retagged] = true
                end
            end
            if arguments[:append] != nil
                attribute[:tag_as] = attribute[:tag_as] + "." + arguments[:append]
            end
            next attribute
        end
        if not keep_tags
            new_attributes.each do |attribute|
                if attribute[:retagged] != true
                    attribute.delete(:tag_as)
                end
            end
        end
        new_attributes.each { |attribute| attribute.delete(:retagged) }
        return pattern_copy
    end
    def recursivelyMatch(reference)
        #
        # generate the new regex
        #
        self_as_string = self.without_default_mode_modifiers
        other_regex_as_string = "[:subroutine:#{reference}:]"
        new_regex = /#{self_as_string}#{other_regex_as_string}/
        
        #
        # carry over attributes
        #
        new_regex.group_attributes = self.group_attributes
        return new_regex
    end
    def to_tag(ignore_repository_entry: false, without_optimizations: false)
        if not ignore_repository_entry
            # if this pattern is in the repository, then just return a reference to the repository
            if self.repository_name != nil
                return { include: "##{self.repository_name}" }
            end
        end
        
        regex_as_string = self.without_default_mode_modifiers
        captures = self.captures
        output = {
            match: regex_as_string,
            captures: captures,
        }
        
        # if no regex in the pattern
        if regex_as_string == '()'
            puts "\n\nThere is a newPattern(), or one of its helpers, where no 'match' argument was given"
            puts "Here is the data for the pattern:"
            puts @group_attributes.to_yaml
            raise "Error: see printout above"
        end

        # check for matching after \n
        skip_newline_check = group_attributes.any? {|attribute| attribute[:no_warn_match_after_newline?]}
        if /\\n(.*?)(?:\||\\n|\]|$)/ =~ regex_as_string and not skip_newline_check
            if /[^\^$\[\]\(\)?:+*=!<>\\]/ =~ $1
                puts "\n\nThere is a pattern that likely tries to match characters after \\n\n"
                puts "textmate grammars only operate on a single line, \\n is the last possible character that can be matched.\n"
                puts "Here is the pattern:\n"
                puts regex_as_string
            end
        end
        group_attributes.delete(:no_warn_match_after_newline?)
        
        #
        # Top level pattern
        #
        # summary:
            # this if statement bascially converts this tag:
            # {
            #     match: '(oneThing)'
            #     captures: {
            #         '1' : {
            #             name: "thing.one"
            #         }
            #     }
            # }
            # into this tag:
            # {
            #     match: 'oneThing'
            #     name: "thing.one"
            # }
        if self.has_top_level_group && !without_optimizations
            #
            # remove the group from the regex
            #
            # safety check (should always be false unless some other code is broken)
            if not ( (regex_as_string.size > 1) and (regex_as_string[0] == '(') and (regex_as_string[-1] == ')') )
                raise "\n\nInside Regexp.to_tag, trying to upgrade a group-1 into a tag name, there doesn't seem to be a group one even though there are attributes\nThis is a library-developer bug as this should never happen.\nThe regex is #{self}\nThe groups are#{self.group_attributes}"
            end
            # remove the first and last ()'s
            output[:match] = regex_as_string[1...-1]
            was_first_group_removed = true
            #
            # update the capture groups
            #
            # decrement all of them by one (since the first one was removed)
            new_captures = {}
            for each_group_number, each_group in captures.each_pair
                decremented_by_1 = (each_group_number.to_i - 1).to_s
                new_captures[decremented_by_1] = each_group
            end
            zero_group = new_captures['0']
            # if name is the only value
            if zero_group.is_a?(Hash) && (zero_group[:name] != nil) && zero_group.keys.size == 1
                # remove the 0th capture group
                top_level_group = new_captures.delete('0')
                # add the name to the output
                output[:name] = Grammar.convertTagName(zero_group[:name], 0, @group_attributes, was_first_group_removed: was_first_group_removed)
            end
            output[:captures] = new_captures
        end

        # create real backreferences
        output[:match] = Grammar.fixupBackRefs(output[:match], @group_attributes, was_first_group_removed: was_first_group_removed)
        
        # convert all of the "$match" into their group numbers
        if output[:captures].is_a?(Hash)
            for each_group_number, each_group in output[:captures].each_pair
                if each_group[:name].is_a?(String)
                    output[:captures][each_group_number][:name] = Grammar.convertTagName(each_group[:name], each_group_number, @group_attributes, was_first_group_removed: was_first_group_removed)
                end
            end
        end
        
        # if captures dont exist then dont show them in the output
        if output[:captures] == {}
            output.delete(:captures)
        end
        
        return output
    end
    
    def captures
        captures = {}
        for group_number in 1..self.group_attributes.size
            raw_attributes = @group_attributes[group_number - 1]
            capture_group = {}
            
            # if no attributes then just skip
            if raw_attributes == {}
                next
            end
            
            # comments
            if raw_attributes[:comment] != nil
                capture_group[:comment] = raw_attributes[:comment]
            end
            
            # convert "tag_as" into the TextMate "name"
            if raw_attributes[:tag_as] != nil
                capture_group[:name] = raw_attributes[:tag_as]
            end
            
            # check for "includes" convert it to "patterns"
            if raw_attributes[:includes] != nil
                if not (raw_attributes[:includes].instance_of? Array)
                    raise "\n\nWhen converting a pattern into a tag (to_tag) there was a group that had an 'includes', but the includes wasn't an array\nThe pattern is:#{self}\nThe group attributes are: #{raw_attributes}"
                end
                # create the pattern list
                capture_group[:patterns] = Grammar.convertIncludesToPatternList(raw_attributes[:includes])
            end
            
            # check for "repository", run conversion on it
            if raw_attributes[:repository] != nil
                capture_group[:repository] = Grammar.convertRepository(raw_attributes[:repository])
            end
            
            # a check for :name, and :patterns and tell them to use tag_as and includes instead
            if raw_attributes[:name] or raw_attributes[:patterns]
                raise "\n\nSomewhere there is a name: or patterns: attribute being set (inside of a newPattern() or helper)\ninstead of name: please use tag_as:\ninstead of patterns: please use includes:\n\nThe arguments for the pattern are:\n#{raw_attributes.to_yaml}"
            end
            
            # check for unknown names
            attributes_copy = Marshal.load(Marshal.dump(raw_attributes))
            attributes_copy.delete_if { |k, v| @@textmate_attributes.key? k }
            if attributes_copy.size != 0
                raise "\n\nThere are arugments being given to a newPattern or a helper that are not understood\nThe unknown arguments are:\n#{attributes_copy}\n\nThe normal arguments are#{raw_attributes}"
            end
            
            # set the capture_group
            if capture_group != {}
                captures[group_number.to_s] = capture_group
            end
        end
        return captures
    end
    
    # convert it to a string and have it without the "(?-mix )" part
    def without_default_mode_modifiers()
        as_string = self.to_s
        # if it is the default settings (AKA -mix) then remove it
        if (as_string.size > 6) and (as_string[0..5] == '(?-mix')
            return self.inspect[1..-2]
        else 
            return as_string
        end
    end
    
    # replace all of the () groups with (?:) groups
    # has the side effect of removing all comments
    def without_numbered_capture_groups
        # unescaped ('s can exist in character classes, and character class-style code can exist inside comments.
        # this removes the comments, then finds the character classes: escapes the ('s inside the character classes then 
        # reverse the string so that varaible-length lookaheads can be used instead of fixed length lookbehinds
        as_string_reverse = self.without_default_mode_modifiers.reverse
        no_preceding_escape = /(?=(?:(?:\\\\)*)(?:[^\\]|\z))/
        reverse_character_class_match = /(\]#{no_preceding_escape}[\s\S]*?\[#{no_preceding_escape})/
        reverse_comment_match = /(\)#{no_preceding_escape}[^\)]*#\?\(#{no_preceding_escape})/
        reverse_start_paraenthese_match = /\(#{no_preceding_escape}/
        reverse_capture_group_start_paraenthese_match = /(?<!\?)\(#{no_preceding_escape}/
        
        reversed_but_fixed = as_string_reverse.gsub(/#{reverse_character_class_match}|#{reverse_comment_match}/) do |match_data, more_data|
            # if found a comment, just remove it
            if (match_data.size > 3) and  match_data[-3..-1] == '#?('
                ''
            # if found a character class, then escape any ()'s that are in it
            else
                match_data.gsub reverse_start_paraenthese_match, '\\('.reverse
            end
        end
        # make all capture groups non-capture groups
        reversed_but_fixed.gsub! reverse_capture_group_start_paraenthese_match, '(?:'.reverse
        return Regexp.new(reversed_but_fixed.reverse)
    end
    
    def getQuantifierFromAttributes(option_attributes)
        # by default assume no 
        quantifier = ""
        # 
        # Simplify the quantity down to just :at_least and :at_most
        # 
            attributes_clone = option_attributes.clone
            # convert Enumerators to numbers
            for each in [:at_least, :at_most, :how_many_times?]
                if attributes_clone[each].is_a?(Enumerator)
                    attributes_clone[each] = attributes_clone[each].size
                end
            end
            # extract the data
            at_least       = attributes_clone[:at_least]
            at_most        = attributes_clone[:at_most]
            how_many_times = attributes_clone[:how_many_times?]
            # simplify to at_least and at_most
            if how_many_times.is_a?(Integer)
                at_least = at_most = how_many_times
            end
        #
        # Generate the ending based on :at_least and :at_most
        #
            # if there is no at_least, at_most, or how_many_times, then theres no quantifier
            if at_least == nil and at_most == nil
                quantifier = ""
            # if there is a quantifier
            else
                # if there's no at_least, then assume at_least = 1
                if at_least == nil
                    at_least = 1
                end
                # this is just a different way of "zeroOrMoreOf"
                if at_least == 0 and at_most == nil
                    quantifier = "*"
                # this is just a different way of "oneOrMoreOf"
                elsif at_least == 1 and at_most == nil
                    quantifier = "+"
                # if it is more complicated than that, just use a range
                else
                    quantifier = "{#{at_least},#{at_most}}"
                end
            end
        return quantifier
    end
    
    def self.checkForSingleEntity(regex)
        # unwrap the regex 
        regex_as_string = regex.without_numbered_capture_groups.without_default_mode_modifiers
        debug =  (regex_as_string =~ /[\s\S]*\+[\s\S]*/) && regex_as_string.length < 10 && regex_as_string != "\\s+"
        # remove all escaped characters
        regex_as_string.gsub!(/\\./, "a")
        # remove any ()'s or ['s in the character classes, and replace them with "a"
        regex_as_string.gsub!(/\[[^\]]+\]/) do |match|
            clean_char_class = match[1..-2].gsub(/\[/, "a").gsub(/\(/,"a").gsub(/\)/, "a")
            match[0] + clean_char_class + match[-1]
        end
        
        # extract the ending quantifiers
        zero_or_more = /\*/
        one_or_more = /\+/
        maybe = /\?/
        range = /\{(?:\d+\,\d*|\d*,\d+|\d)\}/
        greedy = /\??/
        possessive = /\+?/
        quantifier = /(?:#{zero_or_more}|#{one_or_more}|#{maybe}|#{range})/
        quantified_ending_pattern = /#{quantifier}#{possessive}#{greedy}\Z/
        quantified_ending = ""
        regex_without_quantifier = regex_as_string.gsub(quantified_ending_pattern) do |match|
            quantified_ending = match
            "" # remove the ending
        end

        # regex without the ending
        main_group = regex.without_default_mode_modifiers
        # remove the quantified ending
        main_group = main_group[0..-(quantified_ending.length + 1)]
        
        entity = nil
        # if its a single character
        if regex_without_quantifier.length == 1
            entity = :single_char
        # if its a single escaped character
        elsif regex_without_quantifier.length == 2 && regex_without_quantifier[0] == "\\"
            entity = :single_escaped_char
        # if it has matching ()'s
        elsif checkForMatchingOuter(regex_without_quantifier, "(", ")")
            entity = :group
        # if it has matching []'s
        elsif checkForMatchingOuter(regex_without_quantifier, "[", "]")
            entity = :character_class
        end
        
        
        return [entity, quantified_ending, main_group]
    end
    
    def processRegexOperator(arguments, operator)
        # first parse the arguments
        other_regex, pattern_attributes = Regexp.processGrammarArguments(arguments, operator)
        if other_regex == nil
            other_regex = //
        end
        # pattern_attributes does not clone well, option_attributes must be the clone
        option_attributes = pattern_attributes.clone
        pattern_attributes.keep_if { |k, v| @@textmate_attributes.key? k }
        option_attributes.delete_if { |k, v| @@textmate_attributes.key? k }
        
        no_attributes = pattern_attributes == {}
        add_capture_group = ! no_attributes

        self_as_string = self.without_default_mode_modifiers
        other_regex_as_string = other_regex.without_default_mode_modifiers
        
        # handle :word_cannot_be_any_of
        if pattern_attributes[:word_cannot_be_any_of] != nil
            # add the boundary
            other_regex_as_string = /(?!\b(?:#{pattern_attributes[:word_cannot_be_any_of].join("|")})\b)#{other_regex_as_string}/
            # don't let the argument carry over to the next regex
            pattern_attributes.delete(:word_cannot_be_any_of)
        end
        
        # compute the endings so the operators can use/handle them
        simple_quantifier_ending = self.getQuantifierFromAttributes(option_attributes)
        
        # create a helper to handle common logic
        groupWrap = ->(regex_as_string) do
            # if there is a simple_quantifier_ending
            if simple_quantifier_ending.length > 0
                non_capture_group_is_needed = true
                # 
                # perform optimizations
                # 
                    single_entity_type, existing_ending, regex_without_quantifier  = Regexp.checkForSingleEntity(/#{regex_as_string}/)
                    # if there is a single entity
                    if single_entity_type != nil
                        # if there is only one 
                        regex_as_string = regex_without_quantifier
                        # if adding an optional condition to a one-or-more, optimize it into a zero-or more
                        if existing_ending == "+" && simple_quantifier_ending == "?"
                            existing_ending = ""
                            simple_quantifier_ending = "*"
                        end
                    end
                # 
                # Handle greedy/non-greedy endings 
                # 
                    if option_attributes[:quantity_preference] == :as_few_as_possible
                        # add the non-greedy quantifier
                        simple_quantifier_ending += "?"
                    # raise an error for an invalid option
                    elsif option_attributes[:quantity_preference] != nil && option_attributes[:quantity_preference] != :as_many_as_possible
                        raise "\n\nquantity_preference: #{option_attributes[:quantity_preference]}\nis an invalid value. Valid values are:\nnil, :as_few_as_possible, :as_many_as_possible"
                    end
                # if the group is not a single entity
                if single_entity_type == nil
                    # wrap the regex in a non-capture group, and then give it a quantity
                    regex_as_string = "(?:#{regex_as_string})"+simple_quantifier_ending
                # if the group is a single entity, then there is no need to wrap it
                else
                    regex_as_string = regex_as_string + simple_quantifier_ending
                end
            end
            # if backtracking isn't allowed, then wrap it in an atomic group
            if option_attributes[:dont_back_track?]
                regex_as_string = "(?>#{regex_as_string})"
            end
            # if it should be wrapped in a capture group, then add the capture group
            if add_capture_group
                regex_as_string = "(#{regex_as_string})"
            end
            regex_as_string
        end
        
        #
        # Set quantifiers
        # 
        if ['maybe', 'oneOrMoreOf', 'zeroOrMoreOf'].include?(operator)
            # then don't allow manual quantification
            if simple_quantifier_ending.length > 0
                raise "\n\nSorry you can't use how_many_times?:, at_least:, or at_most with the #{operator}() function"
            end
            # set the quantifier (which will be applied inside of groupWrap[])
            case operator
                when 'maybe'
                    simple_quantifier_ending = "?"
                when 'oneOrMoreOf'
                    simple_quantifier_ending = "+"
                when 'zeroOrMoreOf'
                    simple_quantifier_ending = "*"
            end
        end
        # 
        # Generate the core regex
        # 
        if operator == 'or'
            new_regex = /(?:#{self_as_string}|#{groupWrap[other_regex_as_string]})/
        # if its any other operator (including the quantifiers)
        else
            new_regex = /#{self_as_string}#{groupWrap[other_regex_as_string]}/
        end
        
        #
        # Make changes to capture groups/attributes
        #
        # update the attributes of the new regex
        if no_attributes
            new_regex.group_attributes = self.group_attributes + other_regex.group_attributes
        else
            new_regex.group_attributes = self.group_attributes + [ pattern_attributes ] + other_regex.group_attributes
        end
        # if there are arributes, then those attributes are top-level
        if (self == //) and (pattern_attributes != {})
            new_regex.has_top_level_group = true
        end
        
        #
        # run tests
        #
        # temporarily implement matchResultOfs for tests
        test_regex = Grammar.fixupBackRefs(new_regex.without_default_mode_modifiers, new_regex.group_attributes, was_first_group_removed: false)
        # suppress the regex warnings "nested repeat operator '?' and '+' was replaced with '*' in regular expression"
        suppress_output do
            test_regex = Regexp.new(test_regex)
        end
        Regexp.runTest(:should_partial_match    , pattern_attributes, ->(each){       not (each =~ test_regex)       } , test_regex)
        Regexp.runTest(:should_not_partial_match, pattern_attributes, ->(each){      (each =~ test_regex) != nil     } , test_regex)
        Regexp.runTest(:should_fully_match      , pattern_attributes, ->(each){   not (each =~ /\A#{test_regex}\z/)  } , test_regex)
        Regexp.runTest(:should_not_fully_match  , pattern_attributes, ->(each){ (each =~ /\A#{test_regex}\z/) != nil } , test_regex)
        return new_regex
    end
    
    def processRegexLookarounds(other_regex, lookaround_name)
        # if it is an array, then join them as an or statement
        if other_regex.is_a?(Array)
            other_regex = Regexp.new("(?:#{Regexp.quote(other_regex.join("|"))})")
        end
        #
        # generate the new regex
        #
        self_as_string = self.without_default_mode_modifiers
        other_regex_as_string = other_regex.without_default_mode_modifiers
        case lookaround_name
            when 'lookAheadFor'      then new_regex = /#{self_as_string}(?=#{ other_regex_as_string})/
            when 'lookAheadToAvoid'  then new_regex = /#{self_as_string}(?!#{ other_regex_as_string})/
            when 'lookBehindFor'     then new_regex = /#{self_as_string}(?<=#{other_regex_as_string})/
            when 'lookBehindToAvoid' then new_regex = /#{self_as_string}(?<!#{other_regex_as_string})/
        end
        
        #
        # carry over attributes
        #
        new_regex.group_attributes = self.group_attributes
        return new_regex
    end
    
    # summary
    #     the 'under the hood' of this feels complicated, but the resulting behavior is simple
    #     (this is abstracted into a class-method because its used in many instance functions)
    #     basically just let the user give either 1. only a pattern, or 2. let them give a Hash that provides more details
    def self.processGrammarArguments(arguments, error_location)
        arg1 = arguments[0]
        # if only a pattern, set attributes to {}
        if arg1.instance_of? Regexp
            other_regex = arg1
            attributes = {}
        # if its a Hash then extract the regex, and use the rest of the hash as the attributes
        elsif arg1.instance_of? Hash
            other_regex = arg1[:match]
            attributes = arg1.clone
            attributes.delete(:match)
        else
            raise "\n\nWhen creating a pattern, there is a #{error_location}() that was called, but the argument was not a Regex pattern or a Hash.\nThe function doesn't know what to do with the arguments:\n#{arguments}"
        end
        return [ other_regex, attributes ]
    end

    #
    # getter/setter for group_attributes
    #
        def group_attributes=(value)
            @group_attributes = value
        end
        
        def group_attributes
            if @group_attributes == nil
                @group_attributes = []
            end
            return @group_attributes
        end
end

class Pattern < Regexp
    # overwrite the new pattern instead of initialize
    def self.new(*args)
        return //.then(*args)
    end
end

#
# Make safe failure for regex methods on strings
#
class String
    # make the without_default_mode_modifiers do nothing for strings
    def without_default_mode_modifiers()
        return self
    end
end

#
# Named patterns
#
@space = /\s/
@spaces = /\s+/
@digit = /\d/
@digits = /\d+/
@standard_character = /\w/
@word = /\w+/
@word_boundary = /\b/
@white_space_start_boundary = /(?<=\s)(?=\S)/
@white_space_end_boundary = /(?<=\S)(?=\s)/
@start_of_document = /\A/
@end_of_document = /\Z/
@start_of_line = /(?:^)/
@end_of_line = /(?:\n|$)/

#
# Helper patterns
#
    def newPattern(*arguments)
        return //.then(*arguments)
    end
    def lookAheadFor(*arguments)
        //.lookAheadFor(*arguments)
    end
    def lookAheadToAvoid(*arguments)
        //.lookAheadToAvoid(*arguments)
    end
    def lookBehindFor(*arguments)
        //.lookBehindFor(*arguments)
    end
    def lookBehindToAvoid(*arguments)
        //.lookBehindToAvoid(*arguments)
    end
    def wordBounds(regex_pattern)
        return lookBehindToAvoid(@standard_character).then(regex_pattern).lookAheadToAvoid(@standard_character)
    end
    def maybe(*arguments)
        //.maybe(*arguments)
    end
    def oneOrMoreOf(*arguments)
        //.oneOrMoreOf(*arguments)
    end
    def zeroOrMoreOf(*arguments)
        //.zeroOrMoreOf(*arguments)
    end
    def matchResultOf(reference)
        //.matchResultOf(reference)
    end
    def recursivelyMatch(reference)
        //.recursivelyMatch(reference)
    end

#
# PatternRange
#
class PatternRange
    attr_accessor :as_tag, :repository_name, :arguments
    
    def __deep_clone__()
        PatternRange.new(@arguments.__deep_clone__)
    end
    
    def initialize(arguments)
        # parameters:
            # comment: (idk why youd ever use this, but it exists for backwards compatibility)
            # tag_as:
            # tag_content_as:
            # apply_end_pattern_last:
            # while:
            # start_pattern:
            # end_pattern:
            # includes:
            # repository:
            # repository_name:

        # save all of the arguments for later
        @arguments = arguments
        # generate the tag so that errors show up
        self.generateTag()
    end
    
    def generateTag()
        
        # generate a tag version
        @as_tag = {}
        key_arguments = @arguments.clone
        
        #
        # comment
        #
        comment = key_arguments[:comment]
        key_arguments.delete(:comment)
        if comment != nil && comment != ""
            @as_tag[:name] = comment
        end
        
        #
        # tag_as
        #
        tag_name = key_arguments[:tag_as]
        key_arguments.delete(:tag_as)
        if tag_name != nil && tag_name != ""
            @as_tag[:name] = tag_name
        end
        
        #
        # tag_content_as
        #
        tag_content_name = key_arguments[:tag_content_as]
        key_arguments.delete(:tag_content_as)
        if tag_content_name != nil && tag_content_name != ""
            @as_tag[:contentName] = tag_content_name
        end
        
        #
        # apply_end_pattern_last
        #
        apply_end_pattern_last = key_arguments[:apply_end_pattern_last]
        key_arguments.delete(:apply_end_pattern_last)
        if apply_end_pattern_last == 1 || apply_end_pattern_last == true
            @as_tag[:applyEndPatternLast] = apply_end_pattern_last
        end
        
        #
        # while
        #
        while_statement = key_arguments[:while]
        key_arguments.delete(:while)
        if while_statement != nil && while_statement != //
            @as_tag[:while] = while_statement
            while_pattern_as_tag = while_statement.to_tag(without_optimizations: true)
            while_captures = while_pattern_as_tag[:captures]
            if while_captures != {} && while_captures.to_s != ""
                @as_tag[:whileCaptures] = while_captures
            end
        end
        
        #
        # start_pattern
        #
        start_pattern = key_arguments[:start_pattern]
        if not ( (start_pattern.is_a? Regexp) and start_pattern != // )
            raise "The start pattern for a PatternRange needs to be a non-empty regular expression\nThe PatternRange causing the problem is:\n#{key_arguments}"
        end
        start_pattern_as_tag =  start_pattern.to_tag(without_optimizations: true)
        # prevent accidental zero length matches
        pattern = nil
        # suppress the regex warnings "nested repeat operator '?' and '+' was replaced with '*' in regular expression"
        suppress_output do
            pattern = /#{start_pattern_as_tag[:match]}/
        end
        if "" =~ pattern and not key_arguments[:zeroLengthStart?] and not pattern.inspect == "/\G/"
            puts "Warning: #{/#{start_pattern_as_tag[:match]}/.inspect}\nmatches the zero length string (\"\").\n\n"
            puts "This means that the patternRange always matches"
            puts "You can disable this warning by settting :zeroLengthStart? to true."
            puts "The tag for this patternRange is \"#{@as_tag[:name]}\"\n\n"
        end
        key_arguments.delete(:zeroLengthStart?)
        
        @as_tag[:begin] = start_pattern_as_tag[:match]
        key_arguments.delete(:start_pattern)
        begin_captures = start_pattern_as_tag[:captures]
        if begin_captures != {} && begin_captures.to_s != ""
            @as_tag[:beginCaptures] = begin_captures
        end
        
        #
        # end_pattern
        #
        end_pattern = key_arguments[:end_pattern]
        if @as_tag[:while] == nil and not end_pattern.is_a?(Regexp) or end_pattern == // 
            raise "The end pattern for a PatternRange needs to be a non-empty regular expression\nThe PatternRange causing the problem is:\n#{key_arguments}"
        end
        if end_pattern != nil
            end_pattern_as_tag = end_pattern.to_tag(without_optimizations: true, ignore_repository_entry: true)
            @as_tag[:end] = end_pattern_as_tag[:match]
            key_arguments.delete(:end_pattern)
            end_captures = end_pattern_as_tag[:captures]
            if end_captures != {} && end_captures.to_s != ""
                @as_tag[:endCaptures] = end_captures
            end
        end
        #
        # includes
        #
        patterns = Grammar.convertIncludesToPatternList(key_arguments[:includes])
        key_arguments.delete(:includes)
        if patterns != []
            @as_tag[:patterns] = patterns
        end
        
        #
        # repository
        #
        repository = key_arguments[:repository]
        key_arguments.delete(:repository)
        if (repository.is_a? Hash) && (repository != {})
            @as_tag[:repository] = Grammar.convertRepository(repository)
        end
        
        # TODO, add more error checking. key_arguments should be empty at this point
    end
    
    def to_tag(ignore_repository_entry: false)
        # if it hasn't been generated somehow, then generate it
        if @as_tag == nil
            self.generateTag()
        end
        
        if ignore_repository_entry
            return @as_tag
        end
        
        if @repository_name != nil
            return {
                include: "##{@repository_name}"
            }
        end
        return @as_tag
    end
    
    def reTag(arguments)
        # create a copy
        the_copy = self.__deep_clone__()
        # reTag the patterns
        the_copy.arguments[:start_pattern] = the_copy.arguments[:start_pattern].reTag(arguments)
        the_copy.arguments[:end_pattern  ] = the_copy.arguments[:end_pattern  ].reTag(arguments) unless the_copy.arguments[:end_pattern  ] == nil
        the_copy.arguments[:while        ] = the_copy.arguments[:while        ].reTag(arguments) unless the_copy.arguments[:while        ] == nil
        # re-generate the tag now that the patterns have changed
        the_copy.generateTag()
        return the_copy
    end
end

#
# Helpers for Tokens
#
class NegatedSymbol
    def initialize(a_symbol)
        @symbol = a_symbol
    end
    def to_s
        return "not(#{@symbol.to_s})"
    end
    def to_sym
        return @symbol
    end
end

class Symbol
    def !@
        return NegatedSymbol.new(self)
    end
end

class TokenHelper
    attr_accessor :tokens
    def initialize(tokens, for_each_token:nil)
        @tokens = tokens
        if for_each_token != nil
            for each in @tokens
                for_each_token[each]
            end
        end
    end
    
    
    def tokensThat(*adjectives)
        matches = @tokens.select do |each_token|
            output = true
            for each_adjective in adjectives
                # make sure to fail on negated symbols
                if each_adjective.is_a? NegatedSymbol
                    if each_token[each_adjective.to_sym] == true
                        output = false
                        break
                    end
                elsif each_token[each_adjective] != true
                    output = false
                    break
                end
            end
            output
        end
        return matches
    end
    
    def representationsThat(*adjectives)
        matches = self.tokensThat(*adjectives)
        return matches.map do |each| each[:representation] end
    end
    
    def lookBehindToAvoidWordsThat(*adjectives)
        array_of_invalid_names = self.representationsThat(*adjectives)
        return /\b/.lookBehindToAvoid(/#{array_of_invalid_names.map { |each| '\W'+each+'|^'+each } .join('|')}/)
    end
    
    def lookAheadToAvoidWordsThat(*adjectives)
        array_of_invalid_names = self.representationsThat(*adjectives)
        return /\b/.lookAheadToAvoid(/#{array_of_invalid_names.map { |each| each+'\W|'+each+'\$' } .join('|')}/)
    end
    
    def that(*adjectives)
        matches = tokensThat(*adjectives)
        return /(?:#{matches.map {|each| Regexp.escape(each[:representation]) }.join("|")})/
    end
end

class Array
    def without(*args)
        copy = self.clone
        for each in args
            copy.delete(each)
        end
        return copy
    end
end
