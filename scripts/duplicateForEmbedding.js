const fs = require("fs");
const _ = require("lodash");

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
    const deleteableRules = selectRulesForDeletion(grammar);
    rewriteRules(
        originalScopeName,
        deleteableRules,
        grammar,
        early_bailout_pattern
    );
    fs.writeFileSync(
        `${__dirname}/../syntaxes/${language}.embedded.${scope}.tmLanguage.json`,
        JSON.stringify(grammar)
    );
}

function selectRulesForDeletion(rule, repositoryName = undefined) {
    if (rule.match) {
        if (repositoryName) {
            return [repositoryName];
        }
        return [];
    }
    if (rule.patterns) {
        if (Object.keys(rule).length == 1) {
            const deleteable = rule.patterns.reduce((array, r) => {
                if (!array) return array;
                const deleteable = selectRulesForDeletion(r);
                if (!deleteable) return false;
                return array.concat(deleteable);
            }, []);
            if (deleteable) {
                return (repositoryName && [repositoryName]) || [];
            }
        }
    }
    if (rule.repository) {
        return Object.keys(rule.repository).reduce((array, key) => {
            const deleteable = selectRulesForDeletion(
                rule.repository[key],
                key
            );
            if (deleteable) {
                array = array.concat(deleteable);
            }
            return array;
        }, []);
    }
    return false;
}

function rewriteRules(originalscopeName, deleteableRules, rule, newEnding) {
    if (rule.include) {
        if (_.includes(deleteableRules, rule.include.slice(1))) {
            rule.include = `${originalscopeName}${rule.include}`;
        }
    }
    if (rule.end) {
        rule.end = `${rule.end}|(?=${newEnding})`;
    }
    if (rule.while) {
        rule.while = `${rule.while}|(?:^\\s+(?!${newEnding}))`;
    }
    if (rule.patterns) {
        rule.patterns.map(r =>
            rewriteRules(originalscopeName, deleteableRules, r, newEnding)
        );
    }
    // rule.repository is apparently allowed, at least in vscode-textmate, its not documented however
    if (rule.repository) {
        rule.repository = _.omit(rule.repository, deleteableRules);
        Object.keys(rule.repository).map(key =>
            rewriteRules(
                originalscopeName,
                deleteableRules,
                rule.repository[key],
                newEnding
            )
        );
    }
    if (rule.captures) {
        Object.keys(rule.captures).map(key => {
            rewriteRules(
                originalscopeName,
                deleteableRules,
                rule.captures[key],
                newEnding
            );
        });
    }
    if (rule.beginCaptures) {
        Object.keys(rule.beginCaptures).map(key => {
            rewriteRules(
                originalscopeName,
                deleteableRules,
                rule.beginCaptures[key],
                newEnding
            );
        });
    }
    if (rule.endCaptures) {
        Object.keys(rule.endCaptures).map(key => {
            rewriteRules(
                originalscopeName,
                deleteableRules,
                rule.endCaptures[key],
                newEnding
            );
        });
    }
    if (rule.whileCaptures) {
        Object.keys(rule.whileCaptures).map(key => {
            rewriteRules(
                originalscopeName,
                deleteableRules,
                rule.whileCaptures[key],
                newEnding
            );
        });
    }
}
