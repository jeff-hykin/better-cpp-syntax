require_relative 'pattern'

class PatternRange < Pattern
    @start_pattern
    @end_pattern
    @while_pattern

    def initialize(arguments)
        if !arguments.is_a? Hash
            raise "PatternRange.new() expects a hash"
        end

        @start_pattern = arguments[:start_pattern]
        @end_pattern = arguments[:end_pattern]
        @while_pattern = arguments[:while_pattern]

        @start_pattern = Pattern.new(@start_pattern) if @start_pattern.is_a? Regexp
        @end_pattern = Pattern.new(@end_pattern) if @end_pattern.is_a? Regexp
        @while_pattern = Pattern.new(@while_pattern) if @while_pattern.is_a? Regexp

        if @while_pattern == nil && @end_pattern == nil
            raise "one of `while_pattern:` or `end_pattern` must be supplied"
        end

        if @while_pattern && @end_pattern
            raise "only one of `while_pattern:` or `end_pattern` must be supplied"
        end

        if arguments[:match]
            raise "match: is not supported in a PatternRange"
        end

        arguments.delete(:start_pattern)
        arguments.delete(:end_pattern)
        arguments.delete(:while_pattern)
    end

    def start_pattern
        @start_pattern
    end

    def to_r
        raise "PatternRange cannot be used as a part of a Pattern"
    end

    def to_tag
        output = {
            begin: @start_pattern.to_r.to_r_s,
        }
        output[:end]   = @end_pattern.to_r.to_r_s   if @end_pattern   != nil
        output[:while] = @while_pattern.to_r.to_r_s if @while_pattern != nil
        output[:name]  = @arguments[:tag_as] if @arguments[:tag_as]   != nil
        output[:contentName] = @arguments[:tag_content_as] if @arguments[:tag_content_as] != nil

        output[:begin] = output[:begin][1..-2] if @start_pattern && @start_pattern.optimize_outer_group?
        output[:end]   = output[:end  ][1..-2] if @end_pattern   && @end_pattern.optimize_outer_group?
        output[:while] = output[:while][1..-2] if @while_pattern && @while_pattern.optimize_outer_group?

        output[:beginCaptures] = convert_group_attributes_to_captures(@start_pattern.collect_group_attributes)
        output[:endCaptures] = convert_group_attributes_to_captures(@start_pattern.collect_group_attributes)
        output[:whileCaptures] = convert_group_attributes_to_captures(@start_pattern.collect_group_attributes)

        output
    end

    def to_s
        start_pattern = (@start_pattern.is_a? Pattern) ? @start_pattern.to_s(2, true) : @start_pattern.inspect
        end_pattern = nil
        while_pattern = nil

        if @end_pattern != nil
            end_pattern = (@end_pattern.is_a? Pattern) ? @end_pattern.to_s(2, true) : @end_pattern.inspect
        end
        if @while_pattern != nil
            while_pattern = (@while_pattern.is_a? Pattern) ? @while_pattern.to_s(2, true) : @while_pattern.inspect
        end

        output = "PatternRange.new("
        output += "\n  start_pattern: " + start_pattern.lstrip
        output += ",\n  end_pattern: " + end_pattern.lstrip if end_pattern.is_a? String
        output += ",\n  while_pattern: " + while_pattern.lstrip if while_pattern.is_a? String
        output += ",\n)"
        
        output
    end
end