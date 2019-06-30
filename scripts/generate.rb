require_relative '../directory.rb'
# 
# Helpers
# 
def build(language_extension_name)
    Process.wait(Process.spawn("ruby", PathFor[:generator][language_extension_name]))
    exit_code = Integer($?)
    if exit_code != 0
        puts "\n\nGenerating the syntax for '#{language_extension_name}' failed: #{exit_code}"
        exit(false)
    end
end

# 
# Process CommandLine input
# 
# if no args then build all of them
if ARGV[0] == nil
    for each_dir in Dir[PathFor[:languages]+"/**"]
        build(File.basename(each_dir))
    end
else
    build(ARGV[0])
end
