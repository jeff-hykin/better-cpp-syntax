# frozen_string_literal: true

require 'digest/sha1'
require 'json'

require_relative 'pattern'
require_relative 'pattern_range'
require_relative 'sub_patterns'

class Grammar
    def self.new_exportable_grammar
        ExportableGrammar.new
    end

    def self.import(path)
        import_grammar = JSON.parse File.read(path)
        grammar = Grammar.new(
            import_grammar["name"],
            import_grammar["scopeName"],
        )
        # import "patterns" into @repository[:$initial_context]
        # import the rest of the repository
        grammar
    end
    def initialize(name, scope_name)
        @name = name
        @scope_name = scope_name
        @repository = {}
    end

    def [](key)
        @repository[key]
    end

    def []=(key, value)
        raise "Use symbols not strings" unless key.is_a? Symbol

        if key.to_s.start_with?("$") && !(["$initial_context"].include? key)
            puts "#{key} is not a valid repository name"
            puts "repository names starting with $ are reserved"
            raise "See above error"
        end

        if key.to_s == "repository"
            puts "#{key} is not a valid repository name"
            puts "the name 'repository' is a reserved name"
            raise "See above error"
        end

        # ensure array is flat and onlt containts patterns
        if value.is_a? Array
            value = value.flatten.map do |item|
                item = Pattern.new(item) unless item.is_a? Pattern
                item
            end
        elsif !value.is_a?(Pattern)
            value = Pattern.new(item)
        end
        # add it to the repository
        @repository[key] = value
        @repository[key]
    end
end

class ExportableGrammar < Grammar
    attr_accessor :exports, :external_repos

    def initialize
        # skip, initalize, new, and new_exportable_grammar, get the file name
        # and the first 5 bytes of the hash to get the seed
        # will not be unique if multiple exportable grammars are created in the same file
        # Don't do that
        @seed = Digest::MD5.hexdigest(caller_locations(3, 1).first.path).slice(0, 10)
        puts @seed
    end

    def []=(key, value)
        if key.to_s == "$initial_context"
            puts "ExportGrammar cannot store to $initial_context"
            raise "See error above"
        end
        super(key, value)
    end

    def export
        # convert all repository keys to a prefixed version unless in exports
        # prefix all include symbols unless in external_repos
        # ensure the grammar does not refer to a symbol not in repository or external_repos
        # ensure the grammar has all keys named in exports
    end
end