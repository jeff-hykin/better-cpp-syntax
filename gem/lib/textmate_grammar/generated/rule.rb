module Generated
    class Rule
        # @return [String] The location of this rule
        attr_accessor :location
    end

    #
    # Represents a rule in the form of { include = '#rule_name'; }
    #
    class IncludeRule < Rule
        # @return [String] The included Rule name
        attr_accessor :rule

        def initialize(rule)
            @rule = rule
        end
    end

    #
    # Represents a rule in the form of { name = 'string'; }
    #
    class NameRule < Rule
        # @return [String] The name of the rule
        attr_accessor :name
    end

    #
    # Represents a rule inf the form of { patterns = (Rule...); }
    #
    class PatternRule < Rule
        # @return [Array<Rule>] The list of rules
        attr_accessor :rules

        def initialize(rules)
            @rules = rules
        end
    end

    class MatchRule < Rule
        # @return [String] The match pattern
        attr_accessor :match
        # @return [String,nil] The name for this rule
        attr_accessor :name
        # @return [Hash<String=>Rule>] The capture rules
        attr_accessor :captures
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
    end
end