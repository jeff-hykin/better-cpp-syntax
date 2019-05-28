Dir.chdir __dir__ # go to this directory
Dir.chdir ".." # go up one dir__

for each_dir in Dir["source/languages/**"]
    exit_code = Process.wait(Process.spawn("ruby", each_dir+"/generate.rb"))
    if exit_code != 0
        exit(exit_code)
    end
end
