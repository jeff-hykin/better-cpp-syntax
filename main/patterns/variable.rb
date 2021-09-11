def variableBounds(regex_pattern)
    lookBehindToAvoid(@standard_character).then(regex_pattern).lookAheadToAvoid(@standard_character)
end
@variable = variableBounds(/[a-zA-Z_][a-zA-Z_0-9]*/)