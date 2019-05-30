# Go to the root dir 
Dir.chdir __dir__ # this file 
Dir.chdir ".."    # up one

for each_file in Dir["syntaxes/**.tmLanguage.json"]
    Process.wait(Process.spawn("node", "lint/index.js", each_file))
    exit_code = Integer($?)
    if exit_code != 0
        exit(false)
    end
end