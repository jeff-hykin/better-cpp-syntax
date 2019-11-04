# frozen_string_literal: true

module Generated
    class Grammar
        # @return [String] The name of the grammar
        attr_accessor :name
        # @return [String] The grammars scope
        attr_accessor :scope_name
        # @return [String] The version of the grammar
        attr_accessor :version
        # @return [String] information for contributers
        attr_accessor :information
        # @return [PatternRule] rules in initial scope
        attr_accessor :patterns
        # @return [Hash<String=>Rule>] the repository of rules
        attr_accessor :repository
        # @return [Hash] other properties
        attr_accessor :other_properties

        def to_h
            default = {
                "name" => @name,
                "scopeName" => @scope_name,
                "version" => @version,
                "information_for_contributors" => @information,
                "repository" => @repository.transform_values(&:to_h),
            }

            other_properties.merge(default).merge(@patterns.to_h)
        end
    end
end