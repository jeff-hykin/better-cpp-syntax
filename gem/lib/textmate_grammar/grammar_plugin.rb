# frozen_string_literal: true

# @abstract Subclass GrammarLinter or GrammarTransform to implement a plugin
class GrammarPlugin
    # The options this plugin supports
    # @return [Array<Symbol>] a list of symbols that represent keys that can
    #   be read by the plugin
    def self.options
        []
    end

    # display the options as they would appear in the source
    # @abstract override this to display the options as they would be entered into
    #   source code
    # @param indent [String] the spaces to indent each line width
    # @param options [Hash] all options passed to the pattern
    # @return [String] the options as a string
    # @note each option should be prepended with +"\\n,#{indent}"+
    # @note only display the options that are unique to this plugin
    def self.display_options(indent, options) # rubocop:disable Lint/UnusedMethodArgument
        raise "Internal error: display_options called with no provided options" if options.empty?

        if self.options.empty?
            raise "Internal error: display_options called on a plugin that provides no options"
        end

        raise "GrammarPlugin::options implemented but GrammarPlugin::display_options has not been"
    end
end

# @abstract Subclass and override {#pre_lint} and/or {#post_lint}
#   to implement a linter
class GrammarLinter < GrammarPlugin
    #
    # Runs the linter on each pattern
    #
    # @param pattern [Pattern, Symbol, Hash] the pattern to lint
    # @param options [Hash] hash of any of the option keys provided by self.options.
    #   options will only be populated when pattern is a Pattern
    #
    # @return [Boolean] the result of the lint
    def pre_lint(pattern, options = {}) # rubocop:disable Lint/UnusedMethodArgument
        true
    end

    #
    # Runs the linter on the entire grammar
    #
    # @param [Hash] grammar_hash The entire grammar
    #
    # @return [Boolean] the result og the lint
    #
    def post_lint(grammar_hash) # rubocop:disable Lint/UnusedMethodArgument
        true
    end
end

# @abstract Subclass and override {#pre_transform} and/or {#post_transform}
#   to implement a transformation
class GrammarTransform < GrammarPlugin
    #
    # Preforms the transformation on each pattern
    #
    # @param pattern [Pattern, Symbol, Hash] the pattern to transform
    # @param grammar [Grammar] the grammar object
    # @param options [Hash] hash of any of the option keys provided by self.options.
    #   options will only be populated when pattern is a Pattern
    #
    # @return [Pattern, Symbol, Hash] The transformed pattern. The return type should
    #   match the type of pattern
    #
    # @note pattern should not be modified
    #
    def pre_transform(pattern, grammar, options = {}) # rubocop:disable Lint/UnusedMethodArgument
        pattern
    end

    #
    # Performs the transformation on the whole grammar
    #
    # @param [Hash] grammar_hash The entire grammar
    #
    # @return [Hash] The transformed grammar
    #
    # @note grammar_hash should not be modified
    #
    def post_transform(grammar_hash)
        grammar_hash
    end
end

class Grammar
    @@linters = []
    @@transforms = []

    #
    # Register a linter plugin
    #
    # @param [GrammarLinter] linter the linter plugin
    #
    # @return [void] nothing
    #
    def self.register_linter(linter)
        @@linters << linter
    end

    #
    # Register a transformation plugin
    #
    # @param [GrammarTransform] transform the transformation plugin
    #
    # @return [void] nothing
    #
    def self.register_transform(transform)
        @@transforms << transform
    end

    #
    # Gets all registered plugins
    #
    # @api private
    #
    # @return [Array<GrammarPlugin>] A list of all plugins
    #
    def plugins
        @@linters + @@transforms
    end
end

#
# Filters a {Pattern#original_arguments} to just the options required for a plugin
#
# @api private
#
# @param [GrammarPlugin] plugin The plugin to filter options
# @param [Pattern, Symbol, Hash] pattern the pattern with options to filter
#
# @return [Hash] the filtered options
#
def filter_options(plugin, pattern)
    options = {}
    if pattern.is_a? Pattern
        options = pattern.original_arguments.select { |k| plugin.options.includes? k }
    end
    options
end

# load default linters and transforms
Dir[File.join(__dir__, 'linters', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'transforms', '*.rb')].each { |file| require file }