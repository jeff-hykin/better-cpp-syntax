const pa = require("path");
const vsctm = require("vscode-textmate");
const argv = require("yargs").argv;
const SpecChecker = require("./specChecker").SpecChecker;

/**
 * @param {vsctm.Registry} registry
 * @param {string} path
 * @param {string[]} fixture
 * @param {object} spec
 */
module.exports = async function(registry, path, fixture, spec) {
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

        const checker = new SpecChecker(spec);

        for (const line of fixture) {
            let r = grammar.tokenizeLine(line, ruleStack);
            ruleStack = r.ruleStack;
            let displayLine = false;
            for (const token of r.tokens) {
                if (!checker.checkToken(line, token)) {
                    displayLine = true;
                    returnValue = false;
                }
            }
            if (displayLine) {
                console.log("line was |%s|", line);
            }
        }
    } catch (e) {
        console.error(e);
        returnValue = false;
    }
    return returnValue;
};
