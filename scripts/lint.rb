require_relative '../directory.rb'

Dir.chdir PathFor[:root]
for each_file in Dir["#{PathFor[:syntaxes]}/**.tmLanguage.json"]
    Process.wait(Process.spawn("node", PathFor[:linter], each_file))
    exit_code = Integer($?)
    if exit_code != 0
        exit(false)
    end
end