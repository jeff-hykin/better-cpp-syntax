# frozen_string_literal: true

require 'textmate_grammar'

g = Grammar.fromTmLanguage("example.tmLanguage.json")

g.debug

begin
    puts g[:abc]
rescue
    puts "correctly failed to read g[:abc]"
end

g[:abc] = "^hel|lo$"

g.debug