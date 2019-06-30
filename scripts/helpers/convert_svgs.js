// just converts the svg to a png
require("convert-svg-to-png").convertFile(each_svg_path, {height: "300"}, process.argv[1])