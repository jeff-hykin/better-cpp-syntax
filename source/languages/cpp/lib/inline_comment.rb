require_relative '../../../../directory'
require_relative PathFor[:textmate_tools]

Grammar.export(insert_namespace_infront_of_new_grammar_repos: true, insert_namespace_infront_of_all_included_repos: false) do |grammar, namespace|
    Pattern.new(
        match: /\/\*/,
        tag_as: "comment.block punctuation.definition.comment.begin",
    ).then(
        # this pattern is complicated because its optimized to never backtrack
        match: Pattern.new(
            tag_as: "comment.block",
            should_fully_match: [ "thing ****/", "/* thing */", "/* thing *******/" ],
            match: zeroOrMoreOf(
                dont_back_track?: true,
                match: Pattern.new(
                    Pattern.new(
                        /[^\*]/
                    ).or(
                        oneOrMoreOf(
                            match: /\*/,
                            dont_back_track?: true,
                        # any character that is not a /
                        ).then(/[^\/]/)
                    )
                ),
            ).then(
                should_fully_match: [ "*/", "*******/" ],
                match: Pattern.new(
                    oneOrMoreOf(
                        match: /\*/,
                        dont_back_track?: true,
                    ).then(/\//)
                ),
                includes: [
                    Pattern.new(
                        match: /\*\//,
                        tag_as: "comment.block punctuation.definition.comment.end"
                    ),
                    Pattern.new(
                        match: /\*/,
                        tag_as: "comment.block"
                    ),
                ]
            )
        )       
    )
end
