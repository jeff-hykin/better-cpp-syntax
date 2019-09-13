# frozen_string_literal: true

require 'digest/sha1'
require 'json'
require 'pp'

require_relative 'pattern'
require_relative 'pattern_range'
require_relative 'sub_patterns'

def top_level_binding
    binding
end

class Grammar
    @@export_grammars = {}

    attr_accessor :repository
    def self.new_exportable_grammar
        ExportableGrammar.new
    end

    def self.fromTmLanguage(path)
        import_grammar = JSON.parse File.read(path)

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

    def initialize(keys)
        required_keys = [:name, :scope_name]
        unless required_keys & keys.keys == required_keys
            puts "Missing one ore more of the required grammar keys"
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
    end

    def [](key)
        @repository[key]
    end

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

    def debug
        pp @repository
    end

    def save_to(dir, inherit_or_embedded = :embedded)
        # steps:
        # rerun export grammars
        # run test ✓
        # run pre linters
        # run any pre transformations
        # generate bailout patterns
        # transform initial_context includes to $base or $self ✓
        # call to_tag on each pattern ✓
        # run post linters
        # move initial context into patterns ✓
        # if version is :auto, populate with git commit ✓
        # save as #{name}.tmLanguage.json pretty printed ✓

        @repository.each do |key, pattern|
            pattern.run_tests if pattern.is_a? Pattern
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
        @repository.transform_values! { |v| convert_initial_context.call(v) }

        output = {
            name: @name,
            scopeName: @scope_name
        }

        to_tag = lambda do |value|
            return value.map { |v| to_tag.call(v) } if value.is_a? Array
            return {"include" => "#" + value.to_s} if value.is_a? Symbol
            value.to_tag
        end
        output[:repository] = @repository.transform_values { |value| to_tag.call(value) }

        output[:patterns] = output[:repository][:$initial_context]
        output[:patterns] ||= []
        output[:repository].delete(:$initial_context)

        output[:version] = auto_version()
        output.merge!(@keys) { |key, old, _new| old }
        puts output[:version]

        out_file = File.open(File.join(dir, "#{@name}.tmLanguage.json"), "w")
        out_file.write(JSON.pretty_generate(output))
        out_file.close
    end

    def auto_version
        return @keys[:version] unless @keys[:version] == :auto
        commit = `git rev-parse HEAD`
        return commit.strip
    rescue StandardError
        return ""
    end
end

class ExportableGrammar < Grammar
    attr_accessor :exports, :external_repos, :parent_grammar

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
    end

    def []=(key, value)
        if key.to_s == "$initial_context"
            puts "ExportGrammar cannot store to $initial_context"
            raise "See error above"
        end
        super(key, value)
        if parent_grammar.is_a? Grammar
            parent_grammar.import(self)
        else
        end
    end

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
end

class ImportGrammar < Grammar
    def initialize(args)
        super(args)
    end

    def [](key)
        unless @repository[key].is_a? Pattern
            raise "#{key} is a not a Pattern and cannot be referenced"
        end

        @repository[key]
    end
end