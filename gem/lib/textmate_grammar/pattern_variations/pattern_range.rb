# frozen_string_literal: true

require_relative "./base_pattern.rb"

#
# Provides the ability to create begin/end and begin/while rules
#
class PatternRange < PatternBase
    attr_reader :start_pattern

    #
    # Creates a new PatternRange
    #
    # @param [Hash] arguments options
    # @option arguments [PatternBase,Regexp,String] :start_pattern the start pattern
    # @option arguments [PatternBase,Regexp,String] :end_pattern the end pattern
    # @option arguments [PatternBase,Regexp,String] :while_pattern the while pattern
    # @option arguments [String] :tag_as the tag for this pattern
    # @option arguments [String] :tag_contents_as the tag for contents of this pattern
    # @option arguments [String] :tag_start_as the tag for the start pattern
    # @option arguments [String] :tag_end_as the tag for the end pattern
    # @option arguments [String] :tag_while_as the tag for the continuation pattern
    #
    # Plugins may add additional options
    # @note exactly one of :end_pattern or :while_pattern is required
    #
    def initialize(arguments)
        @original_arguments = arguments
        @match = nil
        @next_pattern = nil

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
        @start_pattern = PatternBase.new(@start_pattern) unless @start_pattern.is_a? PatternBase
        @stop_pattern = PatternBase.new(@stop_pattern) unless @stop_pattern.is_a? PatternBase

        # store originals for to_s
        @original_start_pattern = @start_pattern
        @original_stop_pattern  = @stop_pattern

        if arguments[:tag_start_as]
            @start_pattern = PatternBase.new(
                match: @start_pattern,
                tag_as: arguments[:tag_start_as],
            )
        end

        tag_stop_as = arguments[:tag_end_as] || arguments[:tag_while_as]

        if tag_stop_as
            @stop_pattern = PatternBase.new(
                match: @stop_pattern,
                tag_as: tag_stop_as,
            )
        end

        raise "match: is not supported in a PatternRange" if arguments[:match]

        @stop_type = arguments[:end_pattern] ? :end_pattern : :while_pattern

        arguments.delete(:start_pattern)
        arguments.delete(:end_pattern)
        arguments.delete(:while_pattern)

        # ensure that includes is either nil or a flat array
        if arguments[:includes]
            arguments[:includes] = [arguments[:includes]] unless arguments[:includes].is_a? Array
            arguments[:includes] = arguments[:includes].flatten
        end

        #canonize end_pattern_last
        arguments[:end_pattern_last] = arguments[:apply_end_pattern_last] if arguments[:apply_end_pattern_last]
        arguments[:end_pattern_last] = arguments[:applyEndPatternLast] if arguments[:applyEndPatternLast]

        arguments.delete(:apply_end_pattern_last)
        arguments.delete(:applyEndPatternLast)

        @arguments = arguments
    end

    #
    # (see PatternBase#__deep_clone__)
    #
    def __deep_clone__
        options = @arguments.__deep_clone__
        options[:start_pattern] = @original_start_pattern.__deep_clone__
        if @stop_type == :end_pattern
            options[:end_pattern] = @original_stop_pattern.__deep_clone__
        else
            options[:while_pattern] = @original_stop_pattern.__deep_clone__
        end
        self.class.new(options)
    end

    #
    # Raises an error to prevent use inside a pattern list
    #
    # @param _ignored ignored
    #
    # @return [void]
    #
    def evaluate(*_ignored)
        raise "PatternRange cannot be used as a part of a Pattern"
    end

    #
    # Raises an error to prevent use inside a pattern list
    #
    # @param _ignored ignored
    #
    # @return [void]
    #
    def do_evaluate_self(*_ignored)
        raise "PatternRange cannot be used as a part of a Pattern"
    end

    #
    # Generate a Textmate rule from the PatternRange
    #
    # @return [Hash] The Textmate rule
    #
    def to_tag
        match_key = { end_pattern: "end", while_pattern: "while" }[@stop_type]
        capture_key = { end_pattern: "endCaptures", while_pattern: "whileCaptures" }[@stop_type]

        start_groups = @start_pattern.collect_group_attributes
        stop_groups = @stop_pattern.collect_group_attributes

        output = {
            "begin" => @start_pattern.evaluate,
            # this is supposed to be start_groups as back references in end and while
            # refer to the start pattern
            match_key => @stop_pattern.evaluate(start_groups, fixup_refereces: true),
            "beginCaptures" => convert_group_attributes_to_captures(start_groups),
            capture_key => convert_group_attributes_to_captures(stop_groups),
        }

        output[:name] = @arguments[:tag_as] unless @arguments[:tag_as].nil?
        output[:contentName] = @arguments[:tag_content_as] unless @arguments[:tag_content_as].nil?

        output["begin"]   = output["begin"][1..-2]   if @start_pattern.optimize_outer_group?
        output[match_key] = output[match_key][1..-2] if @stop_pattern.optimize_outer_group?

        if @arguments[:includes].is_a? Array
            output[:patterns] = convert_includes_to_patterns(@arguments[:includes])
        elsif !@arguments[:includes].nil?
            output[:patterns] = convert_includes_to_patterns([@arguments[:includes]])
        end

        # end_pattern_last
        output["applyEndPatternLast"] = 1 if @arguments[:end_pattern_last]

        output
    end

    #
    # Displays this pattern range as source code that would generate it
    #
    # @return [String] The PatternRange as source code
    #
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
        output += ",\n  includes: " + @arguments[:includes].to_s if @arguments[:includes]
        output += ",\n  end_pattern_last: #{@arguments[:end_pattern_last]}"  if @arguments[:end_pattern_last]
        output += ",\n)"

        output
    end

    #
    # (see PatternBase#map!)
    #
    def map!(map_includes = false, &block)
        yield self

        @start_pattern.map!(map_includes, &block)
        @stop_pattern.map!(map_includes, &block)
        map_includes!(&block) if map_includes

        self
    end

    #
    # (see PatternBase#transform_includes)
    #
    def transform_includes(&block)
        copy = __deep_clone__
        copy.arguments[:includes].map!(&block) if copy.arguments[:includes].is_a? Array

        copy.map!(true) do |s|
            s.arguments[:includes].map!(&block) if s.arguments[:includes].is_a? Array
        end.freeze
    end

    #
    # (see PatternBase#run_tests)
    #
    def run_tests
        s = @start_pattern.run_tests
        e = @stop_pattern.run_tests
        s && e
    end

    #
    # (see PatternBase#inspect)
    #
    def inspect
        super.split(" ")[0] + " start_pattern:" + @start_pattern.inspect + ">"
    end
end