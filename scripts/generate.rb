Dir.chdir __dir__ # go to this directory
Dir.chdir ".." # go up one dir__

for each_dir in Dir["source/languages/**"]
    Process.wait(Process.spawn("ruby", each_dir+"/generate.rb"))
    exit_code = Integer($?)
    if exit_code != 0
        puts "\n\nGenerating the syntax for #{File.basename(each_dir)} failed: #{exit_code}"
        exit(false)
    end
end
