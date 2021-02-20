# frozen_string_literal: true

#
# Checks for names to match expected naming format
# see https://www.sublimetext.com/docs/3/scope_naming.html
#

class StandardNaming < GrammarLinter
    # This is a summarization of the rules on the sublime text website for scope name
    # process:
    # 1. start at root
    # 2. for each component in name
    #    1. if there exists a key with that name
    #       1. if the value is a hash: repeat with next component and that hash
    #       2. otherwise return the value
    #    2. else
    #       1. if there exists a key of "*" return true, otherwise false
    #
    # to ease parsing, there should only every be one valid path
    # if "a" exists, dont add "a.b" to the same key

    # @return [Hash] a summarization of expected names
    EXPECTED_NAMES = {
        "comment" => {
            "line" => true,
            "block" => true,
        }.freeze,
        "constant" => {
            "numeric" => true,
            "language" => true,
            "character" => {"escape" => true}.freeze,
            "other" => true,
        }.freeze,
        "entity" => {
            "name" => {
                "class" => true,
                "struct" => true,
                "enum" => true,
                "union" => true,
                "trait" => true,
                "interface" => true,
                "impl" => true,
                "type" => true,
                "function" => true,
                "namespace" => true,
                "constant" => true,
                "label" => true,
                "section" => true,
                "scope-resolution" => true,
                "tag" => true,
                "attribute-name" => true,
                "other" => true,
            }.freeze,
            "other" => true,
        }.freeze,
        "invalid" => {
            "illegal" => true,
            "deprecated" => true,
            "unknown" => true,
        }.freeze,
        "keyword" => {
            "control" => true,
            "operator" => true,
            "other" => true,
            "declaration" => true,
        }.freeze,
        "markup" => {
            "heading" => true,
            "list" => {
                "numbered" => true,
                "unnumbered" => true,
            }.freeze,
            "bold" => true,
            "italic" => true,
            "inline" => true,
            "underline" => true,
            "inserted" => true,
            "deleted" => true,
            "quote" => true,
            "raw" => {
                "inline" => true,
                "block" => true,
            }.freeze,
            "other" => true,
        }.freeze,
        "meta" => {
            "asm" => true,
            "class" => true,
            "struct" => true,
            "enum" => true,
            "union" => true,
            "trait" => true,
            "interface" => true,
            "declaration" => true,
            "impl" => true,
            "initialization" => true,
            "type" => true,
            "qualified_type" => true,
            "function" => true,
            "parameter" => true,
            "namespace" => true,
            "using-namespace" => true,
            "preprocessor" => true,
            "conditional" => true,
            "annotation" => true,
            "path" => true,
            "function-call" => true,
            "block" => true,
            "group" => true,
            "braces" => true,
            "parens" => true,
            "brackets" => true,
            "generic" => true,
            "template" => true,
            "tag" => true,
            "paragraph" => true,
            "string" => true,
            "interpolation" => true,
            "toc-list" => true,
            "banner" => true,
        }.freeze,
        "punctuation" => {
            "definition" => true,
            "separator" => true,
            "terminator" => true,
            "accessor" => true,
            "section" => true,
            "vararg-ellipses" => true,
        }.freeze,
        "source" => true,
        "storage" => {
            "type" => true,
            "modifier" => true,
        }.freeze,
        "string" => {
            "quoted" => {
                "single" => true,
                "double" => true,
                "other" => true,
            }.freeze,
            "unquoted" => true,
            "regexp" => true,
        }.freeze,
        "support" => {
            "constant" => true,
            "function" => true,
            "module" => true,
            "type" => true,
            "class" => true,
            "other" => true,
        }.freeze,
        "text" => true,
        "variable" => {
            "other" => true,
            "language" => true,
            "function" => true,
            "annotation" => true,
            "parameter" => true,
        }.freeze,
    }.freeze

    #
    # Checks the tag keys at this level
    #
    # @param [Array<string>] tag an array of tag components
    # @param [Numeric] index The index into tag to check
    # @param [Hash] root the hash to check against
    #
    # @return [Boolean] If this is a valid tag
    #
    def recursive_check_tag(tag, index = 0, root = EXPECTED_NAMES)
        if root.has_key?(tag[index])
            next_part = root[tag[index]]
            return recursive_check_tag(tag, index+1, next_part) if next_part.is_a? Hash

            return [next_part, index, root]
        elsif root.has_key? "*"
            return [root["*"], index, root]
        end

        [false, index, root]
    end

    #
    # Checks a tag for standard naming scheme
    #
    # @param [String] tag the tag to check
    #
    # @return [void] nothing
    #
    def check_tag(tag)
        result, pos, root = recursive_check_tag(tag)
        return if result

        valid_prefix = (pos > 0) ? tag[0..(pos-1)].join(".") + "." : ""

        puts "The prefix `#{tag[0..pos].join('.')}' does not follow the standard format"
        puts "The expected prefixes at this level are:"
        root.keys.each do |key|
            if root[:key] == false
                puts "- #{valid_prefix}#{key}"
            else
                puts "  #{valid_prefix}#{key}"
            end
        end
    end

    #
    # Checks for names to match expected naming format
    #
    # @return [True] warnings to not return false
    #
    def pre_lint(pattern, _options)
        return true unless pattern.is_a? PatternBase

        pattern.each(true) do |pat|
            next unless pat.arguments[:tag_as]

            pat.arguments[:tag_as].split(" ").each { |tag| check_tag(tag.split(".")) }
        end

        true
    end
end

Grammar.register_linter(StandardNaming.new)