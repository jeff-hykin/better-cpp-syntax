# frozen_string_literal: true

@space = Pattern.new(/\s/)
@spaces = oneOrMoreOf(@space)
@digit = Pattern.new(/\d/)
@digits = oneOrMoreOf(@digit)
@standard_character = Pattern.new(/\w/)
@word = oneOrMoreOf(@standard_character)
@word_boundary = Pattern.new(/\b/)
@white_space_start_boundary = lookBehindFor(/\s/).lookAheadFor(/\S/)
@white_space_end_boundary = lookBehindFor(/\S/).lookAheadFor(/\s/)
@start_of_document = Pattern.new(/\A/)
@end_of_document = Pattern.new(/\Z/)
@start_of_line = Pattern.new(/^/)
@end_of_line = oneOf(
    [
        Pattern.new(/\n/),
        Pattern.new(/$/),
    ],
)