// get the tokens from the file and process them with the provided function
const pa = require("path");
const chalk = require("chalk");
const vsctm = require("vscode-textmate");
const argv = require("yargs").argv;

/**
 * @param {vsctm.Registry} registry
 * @param {string} path
 * @param {string[]} fixture
 * @param {boolean} showFailureOnly
 * @param {(line: string, token: vsctm.IToken) => boolean} process
 */
module.exports = async function(registry, path, fixture, showFailureOnly, process) {
    let displayedAtLeastOnce = false;
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
        if (
            pa.extname(path).startsWith("x") ||
            pa.extname(path) == ".m" ||
            path.includes("/objc/") ||
            (argv["header-objc"] && pa.extname(path) == ".h")
        ) {
            sourceName = "source.objc";
        }
        if (
            pa.extname(path).includes("X") ||
            pa.extname(path).includes("M") ||
            pa.extname(path) == ".mm" ||
            path.includes("/objcpp/")
        ) {
            sourceName = "source.objcpp";
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
                showFailureOnly || console.log("line was:\n  %s:%d: |%s|", path, lineNumber, line);
                displayedAtLeastOnce = true;
            }
            lineNumber += 1;
        }
    } catch (e) {
        console.error(e);
        returnValue = false;
    }
    if (displayedAtLeastOnce) {
        console.log(chalk.redBright("   Failed"))
    }

    return returnValue;
};
