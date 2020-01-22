# frozen_string_literal: true

module Generated
    class Rule
        # @return [String] The location of this rule
        attr_accessor :location

        def initialize(location)
            @location = location
        end
    end

    #
    # Represents a rule in the form of { include = '#rule_name'; }
    #
    class IncludeRule < Rule
        # @return [String] The included Rule name
        attr_accessor :rule

        def initialize(location, rule)
            super(location)
            @rule = rule
        end

        def to_h
            {"include" => @rule}
        end
    end

    #
    # Represents a rule in the form of { name = 'string'; }
    #
    class NameRule < Rule
        # @return [String] The name of the rule
        attr_accessor :name

        def initialize(location, name)
            super(location)
            @name = name
        end

        def to_h
            {"name" => @name}
        end
    end

    #
    # Represents a rule in the form of { patterns = (Rule...); }
    #
    class PatternRule < Rule
        # @return [Array<Rule>] The list of rules
        attr_accessor :rules

        def initialize(location, rules)
            super(location)
            @rules = rules
        end

        def to_h
            {"patterns" => @rules.map(&:to_h)}
        end
    end

    class MatchRule < Rule
        # @return [String] The match pattern
        attr_accessor :match
        # @return [String,nil] The name for this rule
        attr_accessor :name
        # @return [Hash<String=>Rule>] The capture rules
        attr_accessor :captures

        def initialize(location)
            super(location)
        end

        def to_h
            {
                "match" => @match,
                "name" => @name,
                "captures" => @captures.transform_values(&:to_h),
            }.compact
        end
    end

    class BeginEndRule < Rule
        # @return [String] The begin pattern
        attr_accessor :begin
        # @return [String] The end pattern
        attr_accessor :end
        # @return [String,nil] The name for this rule
        attr_accessor :name
        # @return [String,nil] The name for the contents matched
        attr_accessor :contentName
        # @return [Hash<String=>Rule>] The captures rules for begin
        attr_accessor :beginCaptures
        # @return [Hash<String=>Rule>] The captures rules for end
        attr_accessor :endCaptures

        def initialize(location)
            super(location)
        end

        def to_h
            {
                "begin" => @begin,
                "end" => @end,
                "name" => @name,
                "contentName" => @contentName,
                "beginCaptures" => @beginCaptures.transform_values(&:to_h),
                "endCaptures" => @endCaptures.transform_values(&:to_h),
            }.compact
        end
    end

    class BeginWhileRule < Rule
        # @return [String] The begin pattern
        attr_accessor :begin
        # @return [String] The while pattern
        attr_accessor :while
        # @return [String,nil] The name for this rule
        attr_accessor :name
        # @return [String,nil] The name for the contents matched
        attr_accessor :contentName
        # @return [Hash<String=>Rule>] The captures rules for begin
        attr_accessor :beginCaptures
        # @return [Hash<String=>Rule>] The captures rules for while
        attr_accessor :whileCaptures

        def initialize(location)
            super(location)
        end

        def to_h
            {
                "begin" => @begin,
                "while" => @while,
                "name" => @name,
                "contentName" => @contentName,
                "beginCaptures" => @beginCaptures.transform_values(&:to_h),
                "whileCaptures" => @whileCaptures.transform_values(&:to_h),
            }.compact
        end
    end
end