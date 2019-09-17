# frozen_string_literal: true

@space = /\s/
@spaces = /\s+/
@digit = /\d/
@digits = /\d+/
@standard_character = /\w/
@word = /\w+/
@word_boundary = /\b/
@white_space_start_boundary = /(?<=\s)(?=\S)/
@white_space_end_boundary = /(?<=\S)(?=\s)/
@start_of_document = /\A/
@end_of_document = /\Z/
@start_of_line = /(?:^)/
@end_of_line = /(?:\n|$)/