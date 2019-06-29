const { convertFile } = require("convert-svg-to-png")
const glob = require("glob")
// 
// paths
// 
const svgs_paths = `${__dirname}/../../icons/*.svg`

// convert all the svgs
for (const each_svg_path of glob.sync(svgs_paths)) {
    convertFile(each_svg_path, {height: "300"})
}
