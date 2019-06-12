def generateStdSpace(inline_comment)
    newPattern(
        # NOTE: this pattern can match 0-spaces so long as its still a word boundary
        # this is the intention since things like `int/*comment*/a = 10` are valid in c++
        # this space pattern will match inline /**/ comments that do not contain newlines
        # >0 length match
        match: newPattern(
                at_least: 1,
                quantity_preference: :as_few_as_possible,
                match: newPattern(
                        match: @spaces,
                        dont_back_track?: true
                    ).or(
                        inline_comment
                    )
            # zero length match
            ).or(
                /\b/.or(
                    lookBehindFor(/\W/)
                ).or(
                    lookAheadFor(/\W/)
                ).or(
                    @start_of_document
                ).or(
                    @end_of_document
                )
            ),
        includes: [ inline_comment ],
    )
end