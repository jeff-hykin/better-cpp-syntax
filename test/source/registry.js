const path = require("path");
const fs = require("fs");
const glob = require("glob");
const vsctm = require("vscode-textmate");
const rewriteGrammar = require("./report/rewrite_grammar");
const pathFor = require("./paths");

function getRegistry(getOnigLib) {
    return new vsctm.Registry({
        loadGrammar: sourceName => {
            if (sourceName == null) {
                console.error(
                    `I can't find the language for ${fixtureExtension}`
                );
                process.exit();
            }
            let grammarPath = pathFor.jsonSyntax(
                sourceName.replace(/^source\./, "")
            );
            // check if the syntax exists
            if (!fs.existsSync(grammarPath)) {
                if (
                    ![
                        "source.asm",
                        "source.x86",
                        "source.x86_64",
                        "source.arm"
                    ].includes(sourceName)
                ) {
                    console.error(
                        "requested grammar outside of this repository"
                    );
                }
                return Promise.resolve({});
            }
            console.log(sourceName);
            return Promise.resolve(
                rewriteGrammar(
                    fs.readFileSync(grammarPath).toString(),
                    sourceName
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
