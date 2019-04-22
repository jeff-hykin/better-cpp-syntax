require_relative 'generate.rb'
# this will overwrite the system syntax with the generated syntax
if (/darwin/ =~ RUBY_PLATFORM) != nil
    `cp '#{@syntax_location}.json' '/Applications/Visual Studio Code.app/Contents/Resources/app/extensions/cpp/syntaxes'`
else
    puts "\n\nCurrently the build command is only has support for Mac"
end