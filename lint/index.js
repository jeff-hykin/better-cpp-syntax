const fs = require("fs");
/**
 * @typedef {{
 *      match?: string
 *      begin?: string
 *      end?: string
 *      while?: string
 *      captures?: {[index: string]: TextMateRule}
 *      beginCaptures?: {[index: string]: TextMateRule}
 *      endCaptures?: {[index: string]: TextMateRule}
 *      whileCaptures?: {[index: string]: TextMateRule}
 *      name?: string
 *      contentName?: string
 *      include?: string
 *      patterns?: TextMateRule[]
 *      repositoryName?: string
 * }} TextMateRule
 */

const linters = [
    require("./linters/unresolved"),
    require("./linters/spell_check"),
    require("./linters/duplicate_value")
];

const grammar = JSON.parse(fs.readFileSync(process.argv[2]).toString());
/**
 * @type {TextMateRule[]}
 */
let stack = [];
/**
 * @type {TextMateRule[]}
 */
let repeat = [];
for (const rule of grammar.patterns) {
    stack.push(rule);
}
for (const rule of Object.keys(grammar.repository)) {
    let r2 = grammar.repository[rule];
    r2.repositoryName = "#" + rule;
    stack.push(r2);
}

while (stack.length != 0) {
    const rule = stack.pop();
    repeat.push(rule);
    for (const linter of linters) {
        if (linter.firstPass) {
            linter.firstPass(rule);
        }
    }
    if (rule.patterns) {
        for (const r2 of rule.patterns) {
            stack.push(r2);
        }
    }
    const processCaptures = key => {
        if (rule[key]) {
            for (const r2Key of Object.keys(rule[key])) {
                let r2 = rule[key][r2Key];
                r2.repositoryName = rule.repositoryName
                    ? rule.repositoryName + "#" + key + r2Key
                    : undefined;
                stack.push(r2);
            }
        }
    };
    processCaptures("captures");
    processCaptures("beginCaptures");
    processCaptures("endCaptures");
    processCaptures("whileCaptures");
}
for (const rule of repeat) {
    for (const linter of linters) {
        if (linter.secondPass) {
            linter.secondPass(rule);
        }
    }
}
console.log();
const result = linters.reduce(
    (result, linter) => (linter.finalReport() ? result : false),
    true
);
console.log(
    "linting for %s: %s",
    process.argv[2],
    result ? "passed" : "failed"
);
