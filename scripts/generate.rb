require_relative '../paths.rb'
#
# Helpers
#

# grabs uncommitted files exactly once
$uncommitted_files = nil
def get_uncommitted
    if $uncommitted_files == nil
        git_status = `git status --porcelain`
        $uncommitted_files = git_status.split("\n").select {|file| /^.[M?]/ =~ file}.map do |file|
            /[M?] (.+)/ =~ file
            File.join(PathFor[:root], $1)
        end
    end
    $uncommitted_files
end

# checks with git to get correct mtime
def mtime(file)
    return File.mtime(file) if get_uncommitted().include? file
    time = `git log -1 --format="%ad" --date=unix #{file}`
    Time.at(time.to_i)
end

def should_build(language_extension_name)
    return true if ARGV[0] == "--force"
    return true if ENV["CI"]
    return true if not File.exists?(PathFor[:jsonSyntax][language_extension_name])

    compare_time = mtime(PathFor[:jsonSyntax][language_extension_name])
    Dir.glob("#{PathFor[:source]}/*.rb") do |file|
        return true if mtime(file) > compare_time
    end
    Dir.glob("#{PathFor[:source]}/shared_patterns/*.rb") do |file|
        return true if mtime(file) > compare_time
    end
    Dir.glob("#{PathFor[:language][language_extension_name]}/**/*.rb") do |file|
        return true if mtime(file) > compare_time
    end
    return false
end


def build(language_extension_name)
    return if not should_build language_extension_name
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
# --force is used to bypass should_build check
check_pos = 0
check_pos = 1 if ARGV[0] == "--force"

if ARGV[check_pos] == nil
    for each_dir in Dir[PathFor[:languages]+"/**"]
        build(File.basename(each_dir))
    end
else
    build(ARGV[check_pos])
end
