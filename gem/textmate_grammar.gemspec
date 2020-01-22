# frozen_string_literal: true

Gem::Specification.new do |s|
    s.name = 'textmate_grammar'
    s.version = '0.0.0'
    s.date = '2019-09-16'
    s.summary = 'A library to generate textmate grammars'
    s.authors = ["Jeff Hykin", "Matthew Fosdick"]
    s.files = Dir["{lib}/**/*.rb", "LICENSE", "*.md"]
    s.homepage = 'https://github.com/jeff-hykin/cpp-textmate-grammar'
    s.license = 'MIT'

    s.required_ruby_version = '>=2.5.0'

    s.metadata = {
        "yard.run" => "yri",
    }
end