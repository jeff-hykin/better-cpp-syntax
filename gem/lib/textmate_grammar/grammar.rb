# frozen_string_literal: true

require 'digest/sha1'
require 'json'
require 'pp'

require_relative 'pattern'
require_relative 'pattern_range'
require_relative 'sub_patterns'


class Grammar
    #
    # A mapping of grammar partials that have been exported
    #
    # @api private
    #
    @@export_grammars = {}

    attr_accessor :repository, :name, :scope_name

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
            version: import_grammar["version"],
            description: import_grammar["description"],
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
    # @option keys all remaning options will be copied to the grammar without change
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

        @keys = keys

        unless @scope_name == "export" || @scope_name.start_with?("source.", "text.")
            puts "Warning: grammar scope name should start with `source.' or `text.'"
            puts "Examples: source.cpp text.html text.html.markdown source.js.regexp"
        end
    end


    #
    # Access a pattern in the grammar
    #
    # @param [Symbol] key The key the pattern is stored in
    #
    # @return [Pattern, Symbol, Array<Pattern, Symbol>] The stored pattern
    #
    def [](key)
        @repository[key]
    end


    #
    # Store a pattern
    #
    # A pattern must be stored in the grammar for it to appear in the final grammar
    #
    # The special key :$initial_context is the pattern that will be matched at the
    # begining of the document or whenever the root of the grammar is to be matched
    #
    # @param [Symbol] key The key to store the pattern in
    # @param [Pattern, Symbol, Array<Pattern, Symbol>] value the pattern to store
    #
    # @return [Pattern, Symbol, Array<Pattern, Symbol>] the stored pattern
    #
    def []=(key, value)
        raise "Use symbols not strings" unless key.is_a? Symbol

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

        # ensure array is flat and only containts patterns
        if value.is_a? Array
            value = value.flatten.map do |item|
                next item if item.is_a? Symbol
                item = Pattern.new(item) unless item.is_a? Pattern
                item
            end
        elsif !value.is_a?(Pattern)
            value = Pattern.new(value)
        end
        # add it to the repository
        @repository[key] = value
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
        export = path_or_export
        unless path_or_export.is_a? ExportableGrammar
            require path
            export = @@export_grammars[path]
        end

        export = export.export
        export.parent_grammar = self

        # import the repository
        @repository = @repository.merge export.repository do |_key, old_val, new_val|
            [old_val, new_val].flatten.uniq
        end
    end

    #
    # Convert the grammar into a hash suitable for exporting to a file
    #
    # @param [:inherit, :embedded] inherit_or_embedded Is this grammar being inherited
    #   from, or will be embedded, this controls if :$initial_context is mapped to
    #   +"$base"+ or +"$self"+
    #
    # @return [Hash] the generated grammar
    #
    def generate(inherit_or_embedded = :embedded)
        # steps:
        # run pre linters ✓
        # run pre transformations ✓
        # generate bailout patterns
        # transform initial_context includes to $base or $self ✓
        # call to_tag on each pattern ✓
        # move initial context into patterns ✓
        # if version is :auto, populate with git commit ✓
        # run post transformations ✓
        # run post linters ✓

        @@linters.each do |linter|
            @repository.each do |key, value|
                if value.is_a? Array
                    value.each do |v|
                        raise "linting failed, see above error" unless linter.pre_lint(key, v, filter_options(linter, v))
                    end
                else
                    raise "linting failed, see above error" unless linter.pre_lint(key, value, filter_options(linter, value))
                end
            end
        end

        repository_copy = @repository.__deep_clone__
        @@transforms.each do |transform|
            repository_copy = repository_copy.transform_values do |value|
                if value.is_a? Array
                    value.map do |v|
                        transform.pre_transform(value, self, filter_options(transform, v))
                    end
                else
                    transform.pre_transform(value, self, filter_options(transform, value))
                end
            end
        end

        convert_initial_context = lambda do |value|
            return (inherit_or_embedded == :embedded ? :$self : :$base) if value == :$initial_context
            if value.is_a? Array
                return value.map { |d| convert_initial_context.call(d) }
            end
            if value.is_a? Pattern
                return value.transform_includes { |d| convert_initial_context.call(d) }
            end
            return value
        end
        repository_copy.transform_values! { |v| convert_initial_context.call(v) }

        output = {
            name: @name,
            scopeName: @scope_name
        }

        to_tag = lambda do |value|
            return value.map { |v| to_tag.call(v) } if value.is_a? Array
            return {"include" => "#" + value.to_s} if value.is_a? Symbol
            value.to_tag
        end
        output[:repository] = repository_copy.transform_values { |value| to_tag.call(value) }

        output[:patterns] = output[:repository][:$initial_context]
        output[:patterns] ||= []
        output[:repository].delete(:$initial_context)

        output[:version] = auto_version()
        output.merge!(@keys) { |key, old, _new| old }

        @@transforms.each { |transform| output = transform.post_transform(output) }

        @@linters.each do |linter|
            raise "linting failed, see above error" unless linter.post_lint(output)
        end

        output
    end

    #
    # Save the grammar to a path
    #
    # @param [Hash] options options to save_to
    # @option options :inherit_or_embedded (:embedded) see {#generate}
    # @option options :generate_tags [Boolean] (true) generate a list of all +:tag_as+s
    # @option options :dir [String] the location to generate the files
    # @option options :tag_dir [String] (File.join(options[:dir],"language_tags")) the
    #   directory to generate language tags in
    # @option options :syntax_dir [String] (File.join(options[:dir],"syntaxes")) the
    #   directory to generate the syntax file in
    # @options options :syntax_format [:json,:vscode,:plist,:textmate,:tm_language,:xml]
    #   (:json) The format to generate the syntax file in
    # @options options :syntax_name [String] ("#{@name}.tmLanguage") the name of the syntax
    #   file to generate without the extension
    #
    # @note all keys except :dir is optional
    # @note :dir is optional if both :tag_dir and :syntax_dir are specified
    # @note currently :vscode is an alias for :json
    # @note currently :textmate, :tm_language, and :xml are aliases for :plist
    # @note later the aliased :syntax_type choices may enable compatibility features
    #
    # @return [void] nothing
    #
    def save_to(options)
        default = {
            inherit_or_embedded: :embedded,
            generate_tags: true,
            syntax_format: :json,
            syntax_name: "#{@name}.tmLanguage",
            syntax_dir: File.join(options[:dir],"syntaxes"),
            tag_dir: File.join(options[:dir],"language_tags"),
        }

        options = default.merge(options)
        output = generate(options[:inherit_or_embedded])

        if [:json, :vscode].includes? options[:syntax_format]
            out_file = File.open(File.join(options[:syntax_dir], "#{options[:syntax_name]}.json"), "w")
            out_file.write(JSON.pretty_generate(output))
            out_file.close
        elsif [:plist, :textmate, :tm_language, :xml].include? options[:syntax_format]
            require 'plist'
            out_file = File.open(File.join(options[:syntax_dir], "#{options[:syntax_name]}"), "w")
            out_file.write(Plist::Emit.dump(output))
            out_file.close
        else
            puts "unxpected syntax format #{options[:syntax_format]}"
            puts "expected one of [:json, :vscode, :plist, :textmate, :tm_language, :xml]"
            raise "see above error"
        end
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
        commit = `git rev-parse HEAD`
        return commit.strip
    rescue StandardError
        return ""
    end
end

class ExportableGrammar < Grammar
    # @return [Array<Symbol>] names that will be exported by the grammar partial
    attr_accessor :exports
    # @return [Array<Symbol>] external names the this grammar partial may reference
    attr_accessor :external_repos
    #
    # Grammars that are a parent to this grammar partial
    #
    # @api private
    #
    attr_accessor :parent_grammar

    #
    # Initialize a new Exportable Grammar
    # @note use {Grammar.new_exportable_grammar} instead
    #
    def initialize
        # skip: initalize, new, and new_exportable_grammar
        location = caller_locations(3, 1).first
        # and the first 5 bytes of the hash to get the seed
        # will not be unique if multiple exportable grammars are created in the same file
        # Don't do that
        @seed = Digest::MD5.hexdigest(location.path)[0..10]
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

    def fixupValue(value)
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
            value.map fixupValue
        elsif value.is_a? Pattern
            value.transform_includes { |v| fixupValue(v) }
        else
            raise "Unexpected object of type #{value.class} in value"
        end
    end
    private :fixupValue
end

class ImportGrammar < Grammar
    # (see Grammar#initialize)
    def initialize(args)
        super(args)
    end

    # (see Grammar#[])
    # @note patterns that have been imported from a file cannot be be accessed
    def [](key)
        if @repository[key].is_a? Hash
            raise "#{key} is a not a Pattern and cannot be referenced"
        end

        @repository[key]
    end
end

require_relative 'grammar_plugin'