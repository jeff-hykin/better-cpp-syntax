# Go to the root dir 
Dir.chdir __dir__ # this file 
Dir.chdir ".."    # up one

for each_file in Dir["syntaxes/**.tmLanguage.json"]
    exit_code = Process.wait(Process.spawn("node", "lint/index.js", each_file))
    if exit_code != 0
        exit(exit_code)
    end
end