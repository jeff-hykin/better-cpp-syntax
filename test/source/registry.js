const path = require("path");
const fs = require("fs");
const glob = require("glob");
const vsctm = require("vscode-textmate");
const rewriteGrammar = require("./report/rewrite_grammar");

const testDir = path.dirname(__dirname);


function getRegistry(getOnigLib) {
    return new vsctm.Registry({
        loadGrammar: scopeName => {
            let extension = scopeName.replace(/source\./, "");
            let grammarPath = `${testDir}/../syntaxes/${extension}.tmLanguage.json`;
            // check if the syntax exists
            if (!fs.existsSync(grammarPath)) {
                console.error("requested grammar outside of this repository");
                return Promise.resolve({});
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
