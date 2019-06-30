require_relative '../directory.rb'

for each in Dir[PathFor[:fixtures]+"/**/*"]
    if File.file?(each)
        puts "#{File.basename(each)}"
        `node #{PathFor[:report]} perf2 "#{each}"`
    end
end
