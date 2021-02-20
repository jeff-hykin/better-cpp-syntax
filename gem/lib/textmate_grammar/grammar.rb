# frozen_string_literal: true

require 'digest/sha1'
require 'json'
require 'pp'
require 'pathname'

require_relative 'import_patterns'

#
# Represents a Textmate Grammar
#
class Grammar
    #
    # A mapping of grammar partials that have been exported
    #
    # @api private
    #
    @@export_grammars = {}

    attr_accessor :repository
    attr_accessor :name
    attr_accessor :scope_name

    #
    # Create a new Exportable Grammar (Grammar Partial)
    #
    # @return [ExportableGrammar] the new exportable Grammar
    #
    def self.new_exportable_grammar
        ExportableGrammar.new
    end

    #
    # import an existing grammar from a file
    #
    # @note the imported grammar is write only access to imported keys will raise an error
    #
    # @param [String] path path to a json or plist grammar
    #
    # @return [Grammar] The imported grammar
    #
    def self.fromTmLanguage(path)
        begin
            import_grammar = JSON.parse File.read(path)
        rescue JSON::ParserError
            require 'plist'
            import_grammar = Plist.parse_xml File.read(path)
        end

        grammar = ImportGrammar.new(
            name: import_grammar["name"],
            scope_name: import_grammar["scopeName"],
            version: import_grammar["version"] || "",
            description: import_grammar["description"] || nil,
            information_for_contributors: import_grammar["information_for_contributors"] || nil,
            fileTypes: import_grammar["fileTypes"] || nil,
        )
        # import "patterns" into @repository[:$initial_context]
        grammar.repository[:$initial_context] = import_grammar["patterns"]
        # import the rest of the repository
        import_grammar["repository"].each do |key, value|
            # repository keys are kept as a hash
            grammar.repository[key.to_sym] = value
        end
        grammar
    end
    
    #
    # Import a grammar partial
    #
    # @note the import is "dynamic", changes made to the grammar partial after the import
    #   wil be reflected in the parent grammar
    #
    # @param [String, ExportableGrammar] path_or_export the grammar partial or the file
    #   in which the grammar partial is declared
    #
    # @return [ExportableGrammar]
    #
    def self.import(path_or_export)
        export = path_or_export
        unless path_or_export.is_a? ExportableGrammar
            # allow for relative paths
            if not Pathname.new(path_or_export).absolute?
                relative_path = File.dirname(caller_locations[0].path)
                if not Pathname.new(relative_path).absolute?
                    relative_path = File.join(Dir.pwd,relative_path)
                end
                path_or_export = File.join(relative_path, path_or_export)
            end
            require path_or_export
            resolved = File.expand_path resolve_require(path_or_export)

            export = @@export_grammars.dig(resolved, :grammar)
            unless export.is_a? ExportableGrammar
                raise "#{path_or_export} does not create a Exportable Grammar"
            end
        end

        return export.export
    end

    #
    # Create a new Grammar
    #
    # @param [Hash] keys The grammar keys
    # @option keys [String] :name The name of the grammar
    # @option keys [String] :scope_name The scope_name of teh grammar, must start with
    #   +source.+ or +text.+
    # @option keys [String, :auto] :version (:auto) the version of the grammar, :auto uses
    #   the current git commit as the version
    # @option keys [Array] :patterns ([]) ignored, will be replaced with the initial context
    # @option keys [Hash] :repository ({}) ignored, will be replaced by the generated rules
    # @option keys all remaining options will be copied to the grammar without change
    #
    def initialize(keys)
        required_keys = [:name, :scope_name]
        unless required_keys & keys.keys == required_keys
            puts "Missing one or more of the required grammar keys"
            puts "Missing: #{required_keys - (required_keys & keys.keys)}"
            puts "The required grammar keys are: #{required_keys}"
            raise "See above error"
        end

        @name = keys[:name]
        @scope_name = keys[:scope_name]
        @repository = {}

        keys.delete :name
        keys.delete :scope_name

        # auto versioning, when save_to is called grab the latest git commit or "" if not
        # a git repo
        keys[:version] ||= :auto
        @keys = keys.compact
        return if @scope_name == "export" || @scope_name.start_with?("source.", "text.")

        puts "Warning: grammar scope name should start with `source.' or `text.'"
        puts "Examples: source.cpp text.html text.html.markdown source.js.regexp"
    end

    #
    # Access a pattern in the grammar
    #
    # @param [Symbol] key The key the pattern is stored in
    #
    # @return [PatternBase, Symbol, Array<PatternBase, Symbol>] The stored pattern
    #
    def [](key)
        if key.is_a?(Regexp)
            tokenMatching(key) # see tokens.rb
        else
            @repository.fetch(key, PlaceholderPattern.new(key))
        end
    end

    #
    # Store a pattern
    #
    # A pattern must be stored in the grammar for it to appear in the final grammar
    #
    # The special key :$initial_context is the pattern that will be matched at the
    # beginning of the document or whenever the root of the grammar is to be matched
    #
    # @param [Symbol] key The key to store the pattern in
    # @param [PatternBase, Symbol, Array<PatternBase, Symbol>] value the pattern to store
    #
    # @return [PatternBase, Symbol, Array<PatternBase, Symbol>] the stored pattern
    #
    def []=(key, value)
        unless key.is_a? Symbol
            raise "Use symbols not strings" unless key.is_a? Symbol
        end

        if key.to_s.start_with?("$") && !([:$initial_context, :$base, :$self].include? key)
            puts "#{key} is not a valid repository name"
            puts "repository names starting with $ are reserved"
            raise "See above error"
        end

        if key.to_s == "repository"
            puts "#{key} is not a valid repository name"
            puts "the name 'repository' is a reserved name"
            raise "See above error"
        end

        # add it to the repository
        @repository[key] = fixup_value(value)
        @repository[key]
    end

    #
    # Import a grammar partial into this grammar
    #
    # @note the import is "dynamic", changes made to the grammar partial after the import
    #   wil be reflected in the parent grammar
    #
    # @param [String, ExportableGrammar] path_or_export the grammar partial or the file
    #   in which the grammar partial is declared
    #
    # @return [void] nothing
    #
    def import(path_or_export)
        
        unless path_or_export.is_a? ExportableGrammar
            relative_path = File.dirname(caller_locations[0].path)
            if not Pathname.new(relative_path).absolute?
                relative_path = File.join(Dir.pwd,relative_path)
            end
            # allow for relative paths
            if not Pathname.new(path_or_export).absolute?
                path_or_export = File.join(relative_path, path_or_export)
            end
        end

        export = Grammar.import(path_or_export)
        export.parent_grammar = self

        # import the repository
        @repository = @repository.merge export.repository do |_key, old_val, new_val|
            [old_val, new_val].flatten.uniq
        end
    end

    #
    # Runs a set of pre transformations
    #
    # @api private
    #
    # @param [Hash] repository The repository
    # @param [:before_pre_linter,:after_pre_linter] stage the stage to run
    #
    # @return [Hash] the modified repository
    #
    def run_pre_transform_stage(repository, stage)
        @@transforms[stage]
            .sort { |a, b| a[:priority] <=> b[:priority] }
            .map { |a| a[:transform] }
            .each do |transform|
                repository = repository.transform_values do |potential_pattern|
                    if potential_pattern.is_a? Array
                        potential_pattern.map do |each|
                            transform.pre_transform(
                                each,
                                filter_options(
                                    transform,
                                    each,
                                    grammar: self,
                                    repository: repository,
                                ),
                            )
                        end
                    else
                        transform.pre_transform(
                            potential_pattern,
                            filter_options(
                                transform,
                                potential_pattern,
                                grammar: self,
                                repository: repository,
                            ),
                        )
                    end
                end
            end

        repository
    end

    #
    # Runs a set of post transformations
    #
    # @param [Hash] output The generated grammar
    # @param [Symbol] stage the stage to run
    #
    # @return [Hash] The modified grammar
    #
    def run_post_transform_stage(output, stage)
        @@transforms[stage]
            .sort { |a, b| a[:priority] <=> b[:priority] }
            .map { |a| a[:transform] }
            .each { |transform| output = transform.post_transform(output) }

        output
    end

    #
    # Convert the grammar into a hash suitable for exporting to a file
    #
    # @param [Symbol] inherit_or_embedded Is this grammar being inherited
    #   from, or will be embedded, this controls if :$initial_context is mapped to
    #   +"$base"+ or +"$self"+
    #
    # @return [Hash] the generated grammar
    #
    def generate(options)
        default = {
            inherit_or_embedded: :embedded,
            should_lint: true,
        }
        options = default.merge(options)
        
        repo = @repository.__deep_clone__
        repo = run_pre_transform_stage(repo, :before_pre_linter)

        if options[:should_lint]
            @@linters.each do |linter|
                repo.each do |_, potential_pattern|
                    [potential_pattern].flatten.each do |each_potential_pattern|
                        raise "linting failed, see above error" unless linter.pre_lint(
                            each_potential_pattern,
                            filter_options(
                                linter,
                                each_potential_pattern,
                                grammar: self,
                                repository: repo,
                            ),
                        )
                    end
                end
            end
        end

        repo = run_pre_transform_stage(repo, :after_pre_linter)

        convert_initial_context = lambda do |potential_pattern|
            if potential_pattern == :$initial_context
                return (options[:inherit_or_embedded] == :embedded) ? :$self : :$base
            end

            if potential_pattern.is_a? Array
                return potential_pattern.map do |nested_potential_pattern|
                    convert_initial_context.call(nested_potential_pattern)
                end
            end

            if potential_pattern.is_a? PatternBase
                return potential_pattern.transform_includes do |each_nested_potential_pattern|
                    # transform includes will call this block again if each_* is a patternBase
                    if each_nested_potential_pattern.is_a? PatternBase
                        next each_nested_potential_pattern
                    end

                    convert_initial_context.call(each_nested_potential_pattern)
                end
            end

            return potential_pattern
        end
        repo = repo.transform_values do |each_potential_pattern|
            convert_initial_context.call(each_potential_pattern)
        end

        output = {
            name: @name,
            scopeName: @scope_name,
        }

        to_tag = lambda do |potential_pattern|
            case potential_pattern
            when Array
                return {
                    "patterns" => potential_pattern.map do |nested_potential_pattern|
                        to_tag.call(nested_potential_pattern)
                    end,
                }
            when Symbol then return {"include" => "#" + potential_pattern.to_s}
            when Hash then return potential_pattern
            when String then return {"include" => potential_pattern}
            when PatternBase then return potential_pattern.to_tag
            else raise "Unexpected value: #{potential_pattern.class}"
            end
        end

        output[:repository] = repo.transform_values do |each_potential_pattern|
            to_tag.call(each_potential_pattern)
        end
        # sort repos by key name
        output[:repository] = Hash[output[:repository].sort_by { |key, _| key.to_s }]

        output[:patterns] = output[:repository][:$initial_context]
        output[:patterns] ||= []
        output[:patterns] = output[:patterns]["patterns"] if output[:patterns].is_a? Hash
        output[:repository].delete(:$initial_context)

        output[:version] = auto_version
        output.merge!(@keys) { |_key, old, _new| old }

        output = run_post_transform_stage(output, :before_pre_linter)
        output = run_post_transform_stage(output, :after_pre_linter)
        output = run_post_transform_stage(output, :before_post_linter)

        @@linters.each do |linter|
            raise "linting failed, see above error" unless linter.post_lint(output)
        end

        output = run_post_transform_stage(output, :after_post_linter)

        Hash[
            output.sort_by do |key, _|
                order = {
                    information_for_contributors: 0,
                    version: 1,
                    name: 2,
                    scopeName: 3,
                    fileTypes: 4,
                    unknown_keys: 5,
                    patterns: 6,
                    repository: 7,
                    uuid: 8,
                }
                next order[key.to_sym] if order.has_key? key.to_sym

                order[:unknown_keys]
            end
        ]
    end

    #
    # Save the grammar to a path
    #
    # @param [Hash] options options to save_to
    # @option options :inherit_or_embedded (:embedded) see #generate
    # @option options :generate_tags [Boolean] (true) generate a list of all +:tag_as+s
    # @option options :directory [String] the location to generate the files
    # @option options :tag_dir [String] (File.join(options[:directory],"language_tags")) the
    #   directory to generate language tags in
    # @option options :syntax_dir [String] (File.join(options[:directory],"syntaxes")) the
    #   directory to generate the syntax file in
    # @option options :syntax_format [:json,:vscode,:plist,:textmate,:tm_language,:xml]
    #   (:json) The format to generate the syntax file in
    # @option options :syntax_name [String] ("#{@name}.tmLanguage") the name of the syntax
    #   file to generate without the extension
    # @option options :tag_name [String] ("#{@name}-scopes.txt") the name of the tag list
    #   file to generate without the extension
    #
    # @note all keys except :directory is optional
    # @note :directory is optional if both :tag_dir and :syntax_dir are specified
    # @note currently :vscode is an alias for :json
    # @note currently :textmate, :tm_language, and :xml are aliases for :plist
    # @note later the aliased :syntax_type choices may enable compatibility features
    #
    # @return [void] nothing
    #
    def save_to(options)
        options[:directory] ||= "."
        
        # make the path absolute 
        absolute_path_from_caller = File.dirname(caller_locations[0].path)
        if not Pathname.new(absolute_path_from_caller).absolute?
            absolute_path_from_caller = File.join(Dir.pwd,absolute_path_from_caller)
        end
        if not Pathname.new(options[:directory]).absolute?
            options[:directory] = File.join(absolute_path_from_caller, options[:directory])
        end
        
        default = {
            inherit_or_embedded: :embedded,
            generate_tags: true,
            syntax_format: :json,
            syntax_name: "#{@scope_name.split('.').drop(1).join('.')}",
            syntax_dir: options[:directory],
            tag_name: "#{@scope_name.split('.').drop(1).join('.')}_scopes.txt",
            tag_dir: options[:directory],
            should_lint: true,
        }
        options = default.merge(options)
        
        output = generate(options)

        if [:json, :vscode].include? options[:syntax_format]
            file_name = File.join(
                options[:syntax_dir],
                "#{options[:syntax_name]}.tmLanguage.json",
            )
            out_file = File.open(file_name, "w")
            out_file.write(JSON.pretty_generate(output))
            out_file.close
        elsif [:plist, :textmate, :tm_language, :xml].include? options[:syntax_format]
            require 'plist'
            file_name = File.join(
                options[:syntax_dir],
                options[:syntax_name],
            )
            out_file = File.open(file_name, "w")
            out_file.write(Plist::Emit.dump(output))
            out_file.close
        else
            puts "unexpected syntax format #{options[:syntax_format]}"
            puts "expected one of [:json, :vscode, :plist, :textmate, :tm_language, :xml]"
            raise "see above error"
        end

        return unless options[:generate_tags]

        file_name = File.join(
            options[:tag_dir],
            options[:tag_name],
        )
        new_file = File.open(file_name, "w")
        new_file.write(get_tags(output).to_a.sort.join("\n"))
        new_file.close
    end

    #
    # Returns the version information
    #
    # @api private
    #
    # @return [String] The version string to use
    #
    def auto_version
        return @keys[:version] unless @keys[:version] == :auto

        `git rev-parse HEAD`.strip
    rescue StandardError
        ""
    end
end

#
# Represents a partial Grammar object
#
# @note this has additional behavior to allow for partial grammars to reuse non exported keys
# @note only one may exist per file
#
class ExportableGrammar < Grammar
    # @return [Array<Symbol>] names that will be exported by the grammar partial
    attr_accessor :exports
    # @return [Array<Symbol>] external names the this grammar partial may reference
    attr_accessor :external_repos
    #
    # Grammars that are a parent to this grammar partial
    #
    # @api private
    # @return [Grammar]
    #
    attr_accessor :parent_grammar

    #
    # Initialize a new Exportable Grammar
    # @note use {Grammar.new_exportable_grammar} instead
    #
    def initialize
        # skip: initialize, new, and new_exportable_grammar
        location = caller_locations(3, 1).first
        # and the first 5 bytes of the hash to get the seed
        # will not be unique if multiple exportable grammars are created in the same file
        # Don't do that
        @seed = Digest::MD5.hexdigest(File.basename(location.path))[0..10]
        super(
            name: "export",
            scope_name: "export"
        )

        if @@export_grammars[location.path].is_a? Hash
            return if @@export_grammars[location.path][:line] == location.lineno

            raise "Only one export grammar is allowed per file"
        end
        @@export_grammars[location.path] = {
            line: location.lineno,
            grammar: self,
        }

        @parent_grammar = []
    end

    #
    # (see Grammar#[]=)
    #
    # @note grammar partials cannot constribute to $initial_context
    #
    def []=(key, value)
        if key.to_s == "$initial_context"
            puts "ExportGrammar cannot store to $initial_context"
            raise "See error above"
        end
        super(key, value)

        parent_grammar.each { |g| g.import self }
    end

    #
    # Modifies the ExportableGrammar to namespace unexported keys
    #
    # @return [self]
    #
    def export
        @repository.transform_keys! do |key|
            next if [:$initial_context, :$base, :$self].include? key

            # convert all repository keys to a prefixed version unless in exports
            if key.to_s.start_with? @seed
                # if exports has changed remove the seed
                bare_key = (key.to_s.split(@seed + "_")[1]).to_sym
                next bare_key if @exports.include? bare_key

                next key
            end

            next key if @exports.include? key

            (@seed + "_" + key.to_s).to_sym
        end
        # prefix all include symbols unless in external_repos or exports
        @repository.transform_values! { |v| fixupValue(v) }
        # ensure the grammar does not refer to a symbol not in repository or external_repos
        # ensure the grammar has all keys named in exports
        exports.each do |key|
            unless @repository.has_key? key
                raise "#{key} is exported but is missing in the repository"
            end
        end
        self
    end

    private

    def fixupValue(value)
        # TDOD: rename this function it is too similar to fixup_value
        if value.is_a? Symbol
            return value if [:$initial_context, :$base, :$self].include? value

            if value.to_s.start_with? @seed
                # if exports or external_repos, has changed remove the seed
                bare_value = (value.to_s.split(@seed + "_")[1]).to_sym
                if @external_repos.include?(bare_value) || @exports.include?(bare_value)
                    return bare_value
                end

                return value
            end

            return value if @external_repos.include?(value) || @exports.include?(value)

            (@seed + "_" + value.to_s).to_sym
        elsif value.is_a? Array
            value.map { |v| fixupValue(v) }
        elsif value.is_a? PatternBase
            value
        else
            raise "Unexpected object of type #{value.class} in value"
        end
    end
end

#
# Represents a Textmate Grammar that has been imported
# This exists entirely to override Grammar#[] and should not be
# normally created
#
# @api private
#
class ImportGrammar < Grammar
    # (see Grammar#initialize)
    def initialize(keys)
        super(keys)
    end

    # (see Grammar#[])
    # @note patterns that have been imported from a file cannot be be accessed
    def [](key)
        raise "#{key} is a not a pattern and cannot be referenced" if @repository[key].is_a? Hash

        @repository[key]
    end
end

require_relative 'grammar_plugin'