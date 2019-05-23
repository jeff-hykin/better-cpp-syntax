const path = require("path");
const fs = require("fs");
const vsctm = require("vscode-textmate");
const rewriteGrammar = require("./pattern-coverage/rewriteGrammar");

const testDir = path.dirname(__dirname);

function getRegistry(getOnigLib) {
    return new vsctm.Registry({
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
                rewriteGrammar(
                    fs.readFileSync(grammarPath).toString(),
                    scopeName
                )
            );
        },
        getOnigLib
    });
}

module.exports = {
    getRegistry,
    default: getRegistry(undefined)
};
