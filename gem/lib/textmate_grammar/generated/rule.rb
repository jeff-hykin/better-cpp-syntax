module Generated
    class Rule
    end

    #
    # Represents a rule in the form of {include: '#rule_name';}
    #
    class IncludeRule < Rule
        # @return [String] The included Rule name
        attr_accessor :rule

        def initialize(rule)
            @rule = rule
        end

        def to_s
            "{ include: '#{@rule}'; }"
        end
    end

    #
    # Represents {pattern: [Rule...]}
    #
    class PatternRule < Rule
        # @return [Array<Rule>] The list of rules
        attr_accessor :rules

        def initialize(rules)
            @rules = rules
        end

        def to_s
            "{ patterns = (\n#{@rules.map { |x| x.to_s }.join(",\n")}\n);\n}"
        end
    end

    class MatchRule < Rule
    end

    class BeginEndRule < Rule
    end

    class BeginWhileRule < Rule
    end
end