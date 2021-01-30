let duplicateForEmbedding = require("textmate-bailout");
let { argv } = require("process");

duplicateForEmbedding({
    grammarFilePath: argv[2],
    appendScope: "macro",
    bailoutPattern: "(?<!\\\\)\n",
    deleteMatchRules: true,
    newFileLocation: argv[3]
});
