const duplicateForEmbedding = require("textmate-bailout")
const fs = require("fs")
const { argv } = require("process")

const newFileLocation = argv[3]
duplicateForEmbedding({
    grammarFilePath: argv[2],
    appendScope: "macro",
    bailoutPattern: "(?<!\\\\)\n",
    deleteMatchRules: true,
    newFileLocation: newFileLocation,
})

const grammarObject = JSON.parse(fs.readFileSync(newFileLocation))
// remove the file types from the generated grammar
grammarObject["fileTypes"] = []
fs.writeFileSync(newFileLocation, JSON.stringify(grammarObject))