# frozen_string_literal: true

class GrammarPlugin
    # a list of symbols that represent keys that can be read by the plugin
    def self.options
        []
    end

    def self.display_options(_indent, options)
        if self.options().empty?
            raise "Internal error: display_options called on a plugin that provides no options"
        end
        if options.empty?
            raise "Internal error: display_options called with no provided options"
        end

        raise "GrammarPlugin::options implemented but GrammarPlugin::display_options has not been"
    end
end

class GrammarLinter < GrammarPlugin
    # runs a linter on each pattern
    # returns false if linting failed
    # pattern may be a (Pattern, Symbol, or Hash)
    def pre_lint(key, pattern)
        true
    end

    # runs a linter on the entire grammar
    # returns false if linting failed
    def post_lint(grammar_hash)
        true
    end
end

class GrammarTransform < GrammarPlugin
    # performs a transformation on each pattern
    # returns the transformed pattern
    # pattern should not be modified
    # pattern may be a (Pattern, Symbol, Hash, or Array of any of the previous)
    def pre_transform(key, pattern, grammar)
        pattern
    end

    # performs a transformation on the entire grammar
    # returns the transformed grammar
    # grammar_hash should no be modified
    def post_transform(grammar_hash)
        grammar_hash
    end
end

class Grammar
    @@linters = []
    @@transforms = []

    def self.register_linter(linter)
        @@linters << linter
    end


    def self.register_transform(transform)
        @@transforms << transform
    end

    def plugins
        @@linters + @@transforms
    end
end

# load default linters and transforms
Dir[File.join(__dir__, 'linters', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'transforms', '*.rb')].each { |file| require file }