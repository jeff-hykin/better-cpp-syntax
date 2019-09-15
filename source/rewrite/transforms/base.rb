class GrammarTransform
    # performs a transformation on each pattern
    # returns the transformed pattern
    # pattern should not be modified
    # pattern may be a (Pattern, Symbol, Hash, or Array of any of the previous)
    def pre_transform(key, pattern, grammar)
        pattern
    end

    # performs a transformation on the entire grammar
    # returns the transformed grammar
    # grammar_hash should no be modified
    def post_transform(grammar_hash)
        grammar_hash
    end
end