const fs = require("fs");

duplicateForEmbedding("cpp", "latex", "\\\\end\\{minted\\}");
// add other languages here

function duplicateForEmbedding(language, scope, early_bailout_pattern) {
    let grammar = JSON.parse(
        fs
            .readFileSync(
                `${__dirname}/../syntaxes/${language}.tmLanguage.json`
            )
            .toString()
    );
    originalScopeName = grammar["scopeName"];
    grammar["scopeName"] = grammar["scopeName"] + ".embedded." + scope;
    rewriteRules(originalScopeName, grammar, early_bailout_pattern);
    fs.writeFileSync(
        `${__dirname}/../syntaxes/${language}.embedded.${scope}.tmLanguage.json`,
        JSON.stringify(grammar)
    );
}

function rewriteRules(
    originalscopeName,
    rule,
    newEnding,
    repositoryName = undefined
) {
    if (rule.end) {
        rule.end = `${rule.end}|(?=${newEnding})`;
    }
    if (rule.while) {
        rule.while = `${rule.while}|(?:^\\s+(?!${newEnding}))`;
    }
    if (rule.patterns) {
        if (Object.keys(rule).length == 1) {
            // If this is a pattern only rule, attempt to rewrite
            const rewrite = rule.patterns.reduce((rewrite, r) => {
                return rewrite && rewriteRules(originalscopeName, r, newEnding);
            });
            if (rewrite) {
                if (!repositoryName || rule.patterns.length == 1) {
                    return true;
                }
                rule.patterns = [
                    { include: `${originalscopeName}#${repositoryName}` }
                ];
            }
        } else {
            rule.patterns.map(r =>
                rewriteRules(originalscopeName, r, newEnding)
            );
        }
    }
    // rule.repository is apparently allowed, at least in vscode-textmate, its not documented however
    if (rule.repository) {
        Object.keys(rule.repository).map(key =>
            rewriteRules(
                originalscopeName,
                rule.repository[key],
                newEnding,
                key
            )
        );
    }
    if (rule.captures) {
        Object.keys(rule.captures).map(key => {
            rewriteRules(originalscopeName, rule.captures[key], newEnding);
        });
    }
    if (rule.beginCaptures) {
        Object.keys(rule.beginCaptures).map(key => {
            rewriteRules(originalscopeName, rule.beginCaptures[key], newEnding);
        });
    }
    if (rule.endCaptures) {
        Object.keys(rule.endCaptures).map(key => {
            rewriteRules(originalscopeName, rule.endCaptures[key], newEnding);
        });
    }
    if (rule.whileCaptures) {
        Object.keys(rule.whileCaptures).map(key => {
            rewriteRules(originalscopeName, rule.whileCaptures[key], newEnding);
        });
    }
    if (rule.match) {
        // match rules cannot effect the ability to bailout as
        // match rules do not have the ability to overshoot
        // replace them with an include to the base grammar
        if (!repositoryName) {
            // if there is not currently a valid rewrite target, signal that this could
            // have been rewritten
            return true;
        }
        rule.patterns = [{ include: `${originalscopeName}#${repositoryName}` }];
        // cleanup rule, assignment doesn't work
        delete rule["match"];
        delete rule["name"];
        delete rule["captures"];
    }
    return false;
}
