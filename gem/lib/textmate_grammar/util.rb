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
    Pattern.new(/^/).then(pat).then(/$/)
end