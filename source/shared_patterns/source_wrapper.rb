def source_wrapper
    # TODO: integrate this feature into the textmate_tools.rb
    # also change the :$initial_context to be (what is currently) the :root_context
    # also add a feature to take a json/hash tmlanguage and convert all the $self and $base's into :$initial_context
    [
        PatternRange.new(
            # the first position
            start_pattern: lookAheadFor(/^/),
            # ensure end never matches
            # why? because textmate will keep looking until it hits the end of the file (which is the purpose of this wrapper)
            # how? because the regex is trying to find "not" and then checks to see if "not" == "possible" (which can never happen)
            end_pattern: /not/.lookBehindFor(/possible/),
            tag_as: "source",
            includes: [:root_context],
        ),
    ]
end