# frozen_string_literal: true

#
# Disables warnings for the block
#
# @return [void]
#
def with_no_warnings
    old_verbose = $VERBOSE
    $VERBOSE = nil
    yield
ensure
    $VERBOSE = old_verbose
end

# Add remove indent to the String class
class String
    # a helper for writing multi-line strings for error messages
    # example usage
    #     puts <<-HEREDOC.remove_indent
    #     This command does such and such.
    #         this part is extra indented
    #     HEREDOC
    # @return [String]
    def remove_indent
        gsub(/^[ \t]{#{match(/^[ \t]*/)[0].length}}/, '')
    end
end

#
# Provides to_s
#
class Enumerator
    #
    # Converts Enumerator to a string representing Integer.times
    #
    # @return [String] the Enumerator as a string
    #
    def to_s
        size.to_s + ".times"
    end
end

# determines if a regex string is a single entity
#
# @note single entity means that for the purposes of modification, the expression is
#   atomic, for example if appending a +*+ to the end of +regex_string+ matches only
#   a part of regex string multiple times then it is not a single_entity
# @param regex_string [String] a string representing a regular expression, without the
#   forward slash "/" at the beginning and
# @return [Boolean] if the string represents an single regex entity
def string_single_entity?(regex_string)
    escaped = false
    in_set = false
    depth = 0
    regex_string.each_char.with_index do |c, index|
        # allow the first character to be at depth 0
        # NOTE: this automatically makes a single char regexp a single entity
        return false if depth == 0 && index != 0

        if escaped
            escaped = false
            next
        end
        if c == '\\'
            escaped = true
            next
        end
        if in_set
            if c == ']'
                in_set = false
                depth -= 1
            end
            next
        end
        case c
        when "(" then depth += 1
        when ")" then depth -= 1
        when "["
            depth += 1
            in_set = true
        end
    end
    # sanity check
    if depth != 0 or escaped or in_set
        puts "Internal error: when determining if a Regexp is a single entity"
        puts "an unexpected sequence was found. This is a bug with the gem."
        puts "This will not effect the validity of the produced grammar"
        puts "Regexp: #{inspect} depth: #{depth} escaped: #{escaped} in_set: #{in_set}"
        return false
    end
    true
end

#
# Wraps a pattern in start and end anchors
#
# @param [PatternBase] pat the pattern to wrap
#
# @return [PatternBase] the wrapped pattern
#
def wrap_with_anchors(pat)
    Pattern.new(/^/).then(Pattern.new(pat)).then(/$/)
end

#
# Fixes value to be either a PatternBase, Symbol, or Array of either
#
# @param [*] value The value to fixup
#
# @return [PatternBase,Symbol,Array<PatternBase,Symbol>] the fixed value
#
def fixup_value(value)
    is_array = value.is_a? Array
    # ensure array is flat and only contains patterns or symbols
    value = [value].flatten.map do |v|
        next v if v.is_a? Symbol

        if v.is_a? String
            next v if v.start_with?("source.", "text.", "$")
        end

        if v.is_a? Hash
            # check for an implicit legacy pattern
            legacy_keys = [
                :name,
                :contentName,
                :begin,
                :end,
                :while,
                :comment,
                :disabled,
                :patterns,
            ]
            v = LegacyPattern.new(v) unless (v.keys.map(&:to_sym) & legacy_keys).empty?
        end

        v = Pattern.new(v) unless v.is_a? PatternBase
        v
    end

    value = value[0] unless is_array
    value
end

#
# Determine the absolute path that a require statement resolves to
#
# @note this assumes path was successfully required previously
#
# @param [String] path the path to resolve
#
# @return [String] the resolved path
#
def resolve_require(path)
    path = Pathname.new path
    return path.to_s if path.absolute? && path.extname != ""

    return path.dirname.glob("#{path.basename}.{rb,so,dll}")[0].to_s if path.absolute?

    $LOAD_PATH.each do |p|
        test_path = Pathname.new(p).join(path)
        return test_path.to_s if path.extname != "" && test_path.exist?

        test_paths = test_path.dirname.glob("#{test_path.basename}.{rb,so,dll}")
        return test_paths[0].to_s unless test_paths.empty?
    end

    ""
end

#
# Converts an output into a set of tags
#
# @param [Hash] output output of Grammar#generate
#
# @return [Set<String>] The tags in the grammar
#
def get_tags(output)
    repository = output[:repository]
    repository[:$initial_context] = {patterns: output[:patterns]}
    tags = Set.new
    add_tags = lambda do |rule|
        rule = rule.transform_keys(&:to_sym)
        tags.merge(rule[:name].split(" ")) if rule[:name]
        tags.merge(rule[:contentName].split(" ")) if rule[:contentName]

        rule[:patterns]&.each { |p| add_tags.call(p) }
        rule[:captures]&.values&.each { |p| add_tags.call(p) }
        rule[:beginCaptures]&.values&.each { |p| add_tags.call(p) }
        rule[:endCaptures]&.values&.each { |p| add_tags.call(p) }
        rule[:whileCaptures]&.values&.each { |p| add_tags.call(p) }
    end

    repository.values.each { |p| add_tags.call(p) }

    tags
end