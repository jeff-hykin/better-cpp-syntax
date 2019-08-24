# frozen_string_literal: true

require_relative 'pattern'

class PatternRange < Pattern
    attr_reader :start_pattern

    def initialize(arguments)
        raise "PatternRange.new() expects a hash" unless arguments.is_a? Hash

        @start_pattern = arguments[:start_pattern]
        @end_pattern   = arguments[:end_pattern]
        @while_pattern = arguments[:while_pattern]

        @original_start_pattern = @start_pattern
        @original_end_pattern   = @end_pattern
        @original_while_pattern = @while_pattern

        @start_pattern = Pattern.new(@start_pattern) unless @start_pattern.is_a? Pattern
        @end_pattern   = Pattern.new(@end_pattern)   unless @end_pattern.is_a? Pattern
        @while_pattern = Pattern.new(@while_pattern) unless @while_pattern.is_a? Pattern

        if @while_pattern.nil? && @end_pattern.nil?
            raise "one of `while_pattern:` or `end_pattern` must be supplied"
        end

        if @while_pattern && @end_pattern
            raise "only one of `while_pattern:` or `end_pattern` must be supplied"
        end

        if @arguments[:tag_start_as]
            @start_pattern = Pattern.new(
                match: @start_pattern,
                tag_as: @arguments[:tag_start_as]
            )
        end

        if @arguments[:tag_end_as]
            @end_pattern = Pattern.new(
                match: @end_pattern,
                tag_as: @arguments[:tag_end_as]
            )
        end

        if @arguments[:tag_while_as]
            @while_pattern = Pattern.new(
                match: @while_pattern,
                tag_as: @arguments[:tag_while_as]
            )
        end

        raise "match: is not supported in a PatternRange" if arguments[:match]

        arguments.delete(:start_pattern)
        arguments.delete(:end_pattern)
        arguments.delete(:while_pattern)
    end

    def to_r(*)
        raise "PatternRange cannot be used as a part of a Pattern"
    end

    def to_tag
        # rubocop:disable Metrics/LineLength
        start_groups = @start_pattern.collect_group_attributes
        output = {
            begin: @start_pattern.evaluate,
        }
        output[:end]         = @end_pattern.evaluate(start_groups)   unless @end_pattern.nil?
        output[:while]       = @while_pattern.evaluate(start_groups) unless @while_pattern.nil?
        output[:name]        = @arguments[:tag_as]                   unless @arguments[:tag_as].nil?
        output[:contentName] = @arguments[:tag_content_as]           unless @arguments[:tag_content_as].nil?

        output[:begin] = output[:begin][1..-2] if @start_pattern&.optimize_outer_group?
        output[:end]   = output[:end]  [1..-2] if @end_pattern&.optimize_outer_group?
        output[:while] = output[:while][1..-2] if @while_pattern&.optimize_outer_group?

        output[:beginCaptures] = convert_group_attributes_to_captures(@start_pattern.collect_group_attributes)
        output[:endCaptures]   = convert_group_attributes_to_captures(@end_pattern.collect_group_attributes)
        output[:whileCaptures] = convert_group_attributes_to_captures(@while_pattern.collect_group_attributes)

        output
        # rubocop:enable Metrics/LineLength
    end

    def to_s
        start_pattern = @original_start_pattern.to_s(2, true)
        end_pattern = nil
        while_pattern = nil

        end_pattern   = @original_end_pattern.to_s(2, true)   unless @end_pattern.nil?
        while_pattern = @original_while_pattern.to_s(2, true) unless @while_pattern.nil?

        output = "PatternRange.new("
        output += "\n  start_pattern: "  + start_pattern.lstrip
        output += ",\n  end_pattern: "   + end_pattern.lstrip   if end_pattern.is_a? String
        output += ",\n  while_pattern: " + while_pattern.lstrip if while_pattern.is_a? String
        [:tag_as, :tag_content_as, :tag_start_as, :tag_end_as, :tag_while_as].each do |tag|
            next if @arguments[tag].nil?

            output += ",\n  #{tag}: " + @arguments[tag] if @arguments[tag].is_a? String
        end
        output += ",\n)"

        output
    end
end