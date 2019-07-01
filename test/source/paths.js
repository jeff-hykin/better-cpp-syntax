const path = require("path");
const glob = require("glob");

const testDir = path.dirname(__dirname)
const root    = path.dirname(testDir)
module.exports = {
    testDir:        path.dirname(__dirname),
    fixtureDir:     path.join(testDir, "fixtures"),
    specDir:        path.join(testDir, "specs"),
    languages:      path.join(root, "source", "languages"),
    eachLanguage:   glob.sync(path.join(root, "source/languages/*")),
    eachJsonSyntax: glob.sync(path.join(root, "syntaxes/*.json")),
}