# frozen_string_literal: true

require 'deep_clone'
require 'yaml'
require 'textmate_grammar/grammar_plugin'
require 'textmate_grammar/util'
require 'textmate_grammar/regex_operator'
require 'textmate_grammar/regex_operators/concat'
require 'textmate_grammar/tokens'

# import Pattern, LegacyPattern, and PatternRange
Dir[File.join(__dir__, 'pattern_variations', '*.rb')].each { |file| require file }
# import .or(), .maybe(), .zeroOrMoreOf(), etc
Dir[File.join(__dir__, 'pattern_extensions', '*.rb')].each { |file| require file }