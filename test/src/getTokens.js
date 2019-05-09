// get the tokens from the file and process them with the provided function
const pa = require("path");
const vsctm = require("vscode-textmate");
const argv = require("yargs").argv;

/**
 * @param {vsctm.Registry} registry
 * @param {string} path
 * @param {string[]} fixture
 * @param {(line: string, token: vsctm.IToken) => boolean} process
 */
module.exports = async function(registry, path, fixture, process) {
    let returnValue = true;
    try {
        let sourceName = "source.cpp";
        if (
            pa.extname(path) == ".c" ||
            path.includes("/c/") ||
            (argv["header-c"] && pa.extname(path) == ".h")
        ) {
            sourceName = "source.c";
        }
        const grammar = await registry.loadGrammar(sourceName);
        let ruleStack = null;
        let lineNumber = 1;
        for (const line of fixture) {
            let r = grammar.tokenizeLine(line, ruleStack);
            ruleStack = r.ruleStack;
            let displayLine = false;
            for (const token of r.tokens) {
                if (!process(line, token)) {
                    displayLine = true;
                    returnValue = false;
                }
            }
            if (displayLine) {
                console.log("line was:\n  %s:%d: |%s|", path, lineNumber, line);
            }
            lineNumber += 1;
        }
    } catch (e) {
        console.error(e);
        returnValue = false;
    }
    return returnValue;
};
