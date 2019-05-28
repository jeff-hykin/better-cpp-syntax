Dir.chdir __dir__ # go to this directory
Dir.chdir ".." # go up one dir__

for each_dir in Dir["source/languages/**"]
    exit_code = Process.wait(Process.spawn("ruby", each_dir+"/generate.rb"))
    # TODO: eventually change this to check for non-zero exit codes
    if exit_code == -1
        puts "Generating the syntaxes fails"
        exit(exit_code)
    end
end
