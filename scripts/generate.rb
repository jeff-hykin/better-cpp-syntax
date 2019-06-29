# 
# paths
# 
$path_to_root = "#{__dir__}/.."
$path_to_languages = $path_to_root + "/source/languages"
def pathToGenerator(language_extension_name)
    return $path_to_languages+"/#{language_extension_name}/generate.rb"
end

# 
# Helpers
# 
def build(language_extension_name)
    Process.wait(Process.spawn("ruby", pathToGenerator(language_extension_name)))
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
    for each_dir in Dir[$path_to_languages+"/**"]
        build(File.basename(each_dir))
    end
else
    build(ARGV[0])
end
