// just converts the svg to a png
require("convert-svg-to-png").convertFile(process.argv[2].replace(/\.png/, ".svg"), {height: "300"}, process.argv[2])