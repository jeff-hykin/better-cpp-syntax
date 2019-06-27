require 'json'

for each in Dir[__dir__() +"/../test/fixtures/**/*"]
    if File.file?(each)
        puts "#{File.basename(each)}"
        `node test/source/commands/report perf2 "#{each}"`
    end
end
