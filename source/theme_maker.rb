# pseudocode for a tool that helps make themes


theme = {
    name: "blah",
    variation: :dark,
    color_palette: {
        bright_red: "#ff5572",
        blue: "#82AAFF",
    },
    least_to_most_important_rules: [
        # highest priority last (things at the bottom over)
        { color: :bright_red, if: :operator and :assignment }
        { color: :blue,       if: :function }
    ]
}


# how the code will work
    # create a Hash called "all_remaining_tm_scopes" 
    # for each tm scope
        # set the key to be the scope itself (the string)
        # open the language specific mapping (a set that is provided for each scope)
        # set the value to the that set
    # iterate over each rule from bottom (last) to top
        # find all the scopes that match the "if:"
        # remove those from the "all_remaining_tm_scopes"
        # store the scopes on that rule
    # on export
        # iterate over each rule and create the traditional theme.json mapping of tm scopes to colors
        # have it tell you if you are missing any scopes (prefer that all scopes are covered by something)