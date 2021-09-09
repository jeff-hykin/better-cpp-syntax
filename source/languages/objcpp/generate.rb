# frozen_string_literal: true

require 'ruby_grammar_builder'

require_relative '../../../paths'

grammar = Grammar.fromTmLanguage(File.join(__dir__, "original.tmLanguage.json"))

# add customizations here

grammar.save_to(
    syntax_dir: PathFor[:syntaxes],
    tag_dir: File.dirname(PathFor[:languageTag]["objcpp"])
)