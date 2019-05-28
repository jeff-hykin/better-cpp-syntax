// this modifies each rule so that regular expressions have their line numbers in them
const jsonSourceMap = require("json-source-map");
const vsctm = require("vscode-textmate");
const coverage = require("./pattern_coverage");

/**
 * @param {Object} pointers
 * @param {vsctm.IRawRule} rule
 * @param {string} jsonPointer
 */
function rewriteRule(rule, jsonPointer, pointers, scopeName) {
    if (rule.match) {
        rule.match = `(?#${scopeName}:${
            pointers[jsonPointer + "/match"].key.line
        })${rule.match}`;
    }
    if (rule.begin) {
        rule.begin = `(?#${scopeName}:${
            pointers[jsonPointer + "/begin"].key.line
        })${rule.begin}`;
    }
    if (rule.end) {
        rule.end = `(?#${scopeName}:${
            pointers[jsonPointer + "/end"].key.line
        })${rule.end}`;
    }
    if (rule.while) {
        rule.while = `(?#${scopeName}:${
            pointers[jsonPointer + "/while"].key.line
        })${rule.while}`;
    }
    if (rule.patterns) {
        rule.patterns.map((r, indx) =>
            rewriteRule(
                r,
                jsonPointer + "/patterns/" + indx,
                pointers,
                scopeName
            )
        );
    }
    if (rule.captures) {
        Object.keys(rule.captures).map(key => {
            rewriteRule(
                rule.captures[key],
                jsonPointer + "/captures/" + key,
                pointers,
                scopeName
            );
        });
    }
    if (rule.beginCaptures) {
        Object.keys(rule.beginCaptures).map(key => {
            rewriteRule(
                rule.beginCaptures[key],
                jsonPointer + "/beginCaptures/" + key,
                pointers,
                scopeName
            );
        });
    }
    if (rule.endCaptures) {
        Object.keys(rule.endCaptures).map(key => {
            rewriteRule(
                rule.endCaptures[key],
                jsonPointer + "/endCaptures/" + key,
                pointers,
                scopeName
            );
        });
    }
    if (rule.whileCaptures) {
        Object.keys(rule.whileCaptures).map(key => {
            rewriteRule(
                rule.whileCaptures[key],
                jsonPointer + "/whileCaptures/" + key,
                pointers,
                scopeName
            );
        });
    }
}
/**
 * @param {string} grammar
 * @param {string} scopeName
 * @returns {vsctm.IRawGrammar}
 */
module.exports = function(grammar, scopeName) {
    const result = jsonSourceMap.parse(grammar);
    rewriteRule(result.data, "", result.pointers, scopeName);
    Object.keys(result.data["repository"]).map(name => {
        rewriteRule(
            result.data["repository"][name],
            `/repository/${name}`,
            result.pointers,
            scopeName
        );
    });
    coverage.loadRecorder(grammar, scopeName);
    return result.data;
};
