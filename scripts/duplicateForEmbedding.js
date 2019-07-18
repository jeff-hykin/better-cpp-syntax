const fs = require("fs");

duplicateForEmbedding("cpp", "latex", "(?=\\\\end\\{minted\\})");
// add other languages here

function duplicateForEmbedding(language, scope, early_bailout_pattern) {
    let grammar = JSON.parse(
        fs
            .readFileSync(
                `${__dirname}/../syntaxes/${language}.tmLanguage.json`
            )
            .toString()
    );
    grammar["scopeName"] = grammar["scopeName"] + ".embedded." + scope;
    rewriteRules(grammar, early_bailout_pattern);
    fs.writeFileSync(
        `${__dirname}/../syntaxes/${language}.embedded.${scope}.tmLanguage.json`,
        JSON.stringify(grammar)
    );
}

function rewriteRules(rule, newEnding) {
    if (rule.end) {
        rule.end = `${rule.end}|${newEnding}`;
    }
    if (rule.patterns) {
        rule.patterns.map(r => rewriteRules(r, newEnding));
    }
    // rule.repository is apparently allowed, at least in vscode-textmate, its not documented however
    if (rule.repository) {
        Object.keys(rule.repository).map(key =>
            rewriteRules(rule.repository[key], newEnding)
        );
    }
    if (rule.captures) {
        Object.keys(rule.captures).map(key => {
            rewriteRules(rule.captures[key], newEnding);
        });
    }
    if (rule.beginCaptures) {
        Object.keys(rule.beginCaptures).map(key => {
            rewriteRules(rule.beginCaptures[key], newEnding);
        });
    }
    if (rule.endCaptures) {
        Object.keys(rule.endCaptures).map(key => {
            rewriteRules(rule.endCaptures[key], newEnding);
        });
    }
    if (rule.whileCaptures) {
        Object.keys(rule.whileCaptures).map(key => {
            rewriteRules(rule.whileCaptures[key], newEnding);
        });
    }
}
