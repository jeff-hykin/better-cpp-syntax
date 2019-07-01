// get the tokens from the file and process them with the provided function
const path = require("path");
const chalk = require("chalk");
const vsctm = require("vscode-textmate-experimental");
const argv = require("yargs").argv;
const paths = require("./paths");
const fs = require("fs");


// retrive all the filetypes from the syntax
let extensionsFor = {}
for (let eachSyntaxPath of paths["eachJsonSyntax"]) {
    let langExtension = path.basename(eachSyntaxPath).replace(/\..+/g,"")
    let syntax = JSON.parse(fs.readFileSync(eachSyntaxPath))
    extensionsFor[langExtension] = syntax["fileTypes"]
}

let languageExtensionFor = (fixturePath) => {
    let fixtureExtension = path.extname(fixturePath).replace(/\./,"");
    let matchingLanguageExtension = null;
    // find which lang the extension belongs to
    for (let eachLangExtension of Object.keys(extensionsFor)) {
        // if the path include the language, then use that
        if (fixturePath.includes(`/${eachLangExtension}/`)) {
            matchingLanguageExtension = eachLangExtension;
            break;
        // if the language extension is in their list, then there
        } else if (extensionsFor[eachLangExtension].includes(fixtureExtension)) {
            matchingLanguageExtension = eachLangExtension;
            break;
        }
    }
    return matchingLanguageExtension;
}

/**
 * @param {vsctm.Registry} registry
 * @param {string} path
 * @param {string[]} fixture
 * @param {boolean} showFailureOnly
 * @param {(line: string, token: vsctm.IToken) => boolean} process
 */
module.exports = async function(registry, fixturePath, fixture, showFailureOnly, process) {
    let displayedAtLeastOnce = false;
    let returnValue = true;
    try {
        let matchingLanguageExtension = languageExtensionFor(fixturePath);
        if (matchingLanguageExtension == null) {
            console.error(`I can't find the language for ${fixtureExtension}`)
            process.exit()
        }
        const grammar = await registry.loadGrammar(`source.${matchingLanguageExtension}`);
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
                showFailureOnly || console.log("line was:\n  %s:%d: |%s|", fixturePath, lineNumber, line);
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
