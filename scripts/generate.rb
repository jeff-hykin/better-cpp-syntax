Dir.chdir __dir__ # go to this directory
Dir.chdir ".." # go up one dir__

for each_dir in Dir["source/languages/**"]
    Process.wait(Process.spawn("ruby", each_dir+"/generate.rb"))
end
