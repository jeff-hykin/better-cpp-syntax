const path = require("path");
const glob = require("glob");
const fs   = require("fs");
const _ = require("lodash")

const testDir            = path.dirname(__dirname)
const fixtures           = path.join(testDir, "fixtures")
const root               = path.dirname(testDir)
const syntaxes           = path.join(root, "syntaxes")
const eachJsonSyntax     = glob.sync(path.join(syntaxes, "*.json"))
const eachLanguage       = glob.sync(path.join(root, "source/languages/*"))
const languageExtensions = eachLanguage.map(each => path.basename(each))
const languageFileTypes  = eachJsonSyntax.map(each => JSON.parse(fs.readFileSync(each))["fileTypes"] )

module.exports = {
    root,
    fixtures,
    tests:          testDir,
    specDir:        path.join(testDir, "specs"),
    languages:      path.join(root, "source", "languages"),
    eachLanguage:   glob.sync(path.join(root, "source/languages/*")),
    eachJsonSyntax: glob.sync(path.join(syntaxes, "*.json")),
    eachFixture:    glob.sync(path.join(fixtures,`**/*.{${_.flattenDeep(languageFileTypes).join(",")}}`)),
    jsonSyntax:     (extensionName) => path.join(syntaxes, `${extensionName}.tmLanguage.json`)
}
