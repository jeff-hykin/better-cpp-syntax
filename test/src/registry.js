const path = require("path");
const fs = require("fs");
const vsctm = require("vscode-textmate");

const testDir = path.dirname(__dirname);

// load the grammars
module.exports = new vsctm.Registry({
    loadGrammar: scopeName => {
        let grammarPath = "";
        switch (scopeName) {
            case "source.cpp":
                grammarPath = path.join(
                    testDir,
                    "../syntaxes",
                    "cpp.tmLanguage.json"
                );
                break;
            case "source.c":
                grammarPath = path.join(
                    testDir,
                    "../syntaxes",
                    "c.tmLanguage.json"
                );
                break;
            default:
                return Promise.reject("requested non c/c++ grammar");
        }
        return Promise.resolve(
            vsctm.parseRawGrammar(fs.readFileSync(grammarPath), grammarPath)
        );
    }
});
