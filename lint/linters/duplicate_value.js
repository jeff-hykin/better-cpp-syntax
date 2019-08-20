/// <reference path="../index.js" />

const crypto = require("crypto");
const _ = require("lodash");
const chalk = require("chalk");

const known_prefixes = ["#macro_safe"];

function clearNestedRepositoryName(rule) {
    delete rule.repositoryName;
    if (rule.patterns) {
        for (let pattern of rule.patterns) {
            clearNestedRepositoryName(pattern);
        }
    }
    function clearCaptures(capture) {
        if (capture === undefined) {
            return;
        }
        for (let key of Object.keys(capture)) {
            clearNestedRepositoryName(capture[key]);
        }
    }
    clearCaptures(rule.captures);
    clearCaptures(rule.beginCaptures);
    clearCaptures(rule.endCaptures);
    clearCaptures(rule.whileCaptures);
}

class DuplicateValue {
    constructor() {
        this.hash_lookup = {};
        this.duplicates = {};
    }
    /**
     * @param {TextMateRule} rule
     */
    firstPass(rule) {
        if (!rule.repositoryName) {
            return;
        }
        if (rule.include) {
            // include rules cannot be simplified
            return;
        }
        if (
            rule.patterns &&
            rule.patterns.length == 1 &&
            rule.patterns[0].include
        ) {
            // capture rules need to have patterns, ignore if include only
            return;
        }
        if (Object.keys(rule).length == 2 && rule.name) {
            // if the rule contains 2 keys of which one is the name (the other is repositoryName)
            // return as name only rules cannot be simplified
            return;
        }
        if (
            rule.begin &&
            _.some(this.known_prefixes, prefix =>
                rule.repositoryName.startsWith(prefix)
            )
        ) {
            // skip begin/* rules that start with a known prefix
            return;
        }
        let hash = crypto.createHash("sha256");
        const hashRule = _.cloneDeep(rule);
        clearNestedRepositoryName(hashRule);
        hash.update(JSON.stringify(hashRule));
        let digest = hash.digest().toString("hex");
        if (this.hash_lookup[digest] === undefined) {
            this.hash_lookup[digest] = rule.repositoryName;
        } else {
            if (this.duplicates[digest]) {
                this.duplicates[digest].push(rule.repositoryName);
            } else {
                this.duplicates[digest] = [
                    this.hash_lookup[digest],
                    rule.repositoryName
                ];
            }
        }
    }

    finalReport() {
        for (const hash of Object.keys(this.duplicates)) {
            console.warn(
                chalk.yellowBright(
                    "[Duplicate]   ",
                    this.duplicates[hash],
                    "are all identical rules, consider using a repository"
                )
            );
        }
        return true;
    }
}

module.exports = new DuplicateValue();
