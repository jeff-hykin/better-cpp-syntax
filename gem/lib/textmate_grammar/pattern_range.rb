# frozen_string_literal: true

require_relative 'pattern'

class PatternRange < Pattern
    attr_reader :start_pattern

    def initialize(arguments)
        raise "PatternRange.new() expects a hash" unless arguments.is_a? Hash

        # ensure end_pattern: XOR while_pattern: is provided
        if arguments[:end_pattern].nil? && arguments[:while_pattern].nil?
            raise "one of `while_pattern:` or `end_pattern` must be supplied"
        end

        if !arguments[:end_pattern].nil? && !arguments[:while_pattern].nil?
            raise "only one of `while_pattern:` or `end_pattern` must be supplied"
        end

        @start_pattern = arguments[:start_pattern]
        @stop_pattern  = arguments[:end_pattern] || arguments[:while_pattern]

        # convert to patterns if needed
        @start_pattern = Pattern.new(@start_pattern) unless @start_pattern.is_a? Pattern
        @stop_pattern = Pattern.new(@stop_pattern) unless @stop_pattern.is_a? Pattern

        # store orginals for to_s
        @original_start_pattern = @start_pattern
        @original_stop_pattern  = @stop_pattern

        if arguments[:tag_start_as]
            @start_pattern = Pattern.new(
                match: @start_pattern,
                tag_as: arguments[:tag_start_as],
            )
        end

        tag_stop_as = arguments[:tag_end_as] || arguments[:tag_while_as]

        if tag_stop_as
            @stop_pattern = Pattern.new(
                match: @stop_pattern,
                tag_as: tag_stop_as,
            )
        end

        raise "match: is not supported in a PatternRange" if arguments[:match]

        @stop_type = arguments[:end_pattern] ? :end_pattern : :while_pattern

        arguments.delete(:start_pattern)
        arguments.delete(:end_pattern)
        arguments.delete(:while_pattern)

        @arguments = arguments
    end

    def evaluate(*)
        raise "PatternRange cannot be used as a part of a Pattern"
    end

    def to_tag
        match_key = { end_pattern: "end", while_pattern: "while" }[@stop_type]
        capture_key = { end_pattern: "endCaptures", while_pattern: "whileCaptures" }[@stop_type]

        start_groups = @start_pattern.collect_group_attributes
        stop_groups = @stop_pattern.collect_group_attributes

        output = {
            "begin" => @start_pattern.evaluate,
            # this is supposed to be start_groups as back references in end and while
            # refer to the start pattern
            match_key => @stop_pattern.evaluate(start_groups),
            "beginCaptures" => convert_group_attributes_to_captures(start_groups),
            capture_key => convert_group_attributes_to_captures(stop_groups),
        }

        output[name] = @arguments[:tag_as] unless @arguments[:tag_as].nil?
        output[:contentName] = @arguments[:tag_content_as] unless @arguments[:tag_content_as].nil?

        output["begin"]   = output["begin"][1..-2]   if @start_pattern.optimize_outer_group?
        output[match_key] = output[match_key][1..-2] if @stop_pattern.optimize_outer_group?

        output
    end

    def to_s
        start_pattern = @original_start_pattern.to_s(2, true)
        stop_pattern = @original_stop_pattern.to_s(2, true)

        output = "PatternRange.new("
        output += "\n  start_pattern: " + start_pattern.lstrip
        output += ",\n  #{@stop_type}: " + stop_pattern.lstrip
        [:tag_as, :tag_content_as, :tag_start_as, :tag_end_as, :tag_while_as].each do |tag|
            next if @arguments[tag].nil?

            output += ",\n  #{tag}: \"" + @arguments[tag] + "\"" if @arguments[tag].is_a? String
        end
        output += ",\n)"

        output
    end

    def reTag!(arguments)
        @start_pattern.reTag!(arguments)
        @stop_pattern.reTag!(arguments)
        self
    end
end