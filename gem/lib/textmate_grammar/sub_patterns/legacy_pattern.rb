# frozen_string_literal: true

class LegacyPattern < PatternBase
    def initialize(hash)
        super("placeholder")
        @hash = hash.transform_keys(&:to_sym)
    end

    def evaluate(*_ignored)
        raise "LegacyPattern cannot be used as a part of a Pattern"
    end

    def insert!(_pattern)
        raise "LegacyPattern cannot be used as a part of a Pattern"
    end

    def to_tag
        @hash
    end

    def run_tests
        true
    end

    def map!(*)
        self
    end

    def __deep_clone__
        self.class.new(@hash)
    end
end