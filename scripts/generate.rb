Dir.chdir __dir__ # go to this directory
Dir.chdir ".." # go up one dir__

def build(language_extension_name)
    Process.wait(Process.spawn("ruby", language_extension_name+"/generate.rb"))
    exit_code = Integer($?)
    if exit_code != 0
        puts "\n\nGenerating the syntax for '#{language_extension_name}' failed: #{exit_code}"
        exit(false)
    end
end

# if no args then build all of them
if ARGV[0] == nil
    for each_dir in Dir["source/languages/**"]
        build(language_extension_name)
    end
else
    build(ARGV[0])
end
