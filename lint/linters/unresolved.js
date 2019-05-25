const chalk = require("chalk");

class Unresolved {
    constructor() {
        this.unused = [];
        this.unresolved = [];
        this.resolved = ["$base", "$self"];
    }
    recordIncludes(rule) {
        if (this.unused.includes(rule.include)) {
            this.unused.splice(this.unused.indexOf(rule.include), 1);
        }
        if (this.resolved.includes(rule.include)) {
            return;
        }
        if (!this.unresolved.includes(rule.include)) {
            this.unresolved.push(rule.include);
        }
    }
    recordRule(rule) {
        // ignore nested rules
        if (rule.repositoryName.lastIndexOf("#") > 0) {
            return;
        }
        if (this.unresolved.includes(rule.repositoryName)) {
            this.unresolved.splice(
                this.unresolved.indexOf(rule.repositoryName),
                1
            );
            this.resolved.push(rule.repositoryName);
            return;
        }
        if (this.resolved.includes(rule.repositoryName)) {
            return;
        }
        if (!this.unused.includes(rule.repositoryName)) {
            this.unused.push(rule.repositoryName);
        }
    }
    /**
     * @param {TextMateRule} rule
     */
    firstPass(rule) {
        if (rule.include) {
            this.recordIncludes(rule);
            return;
        }
        if (rule.repositoryName) {
            this.recordRule(rule);
        }
    }
    secondPass(rule) {
        if (rule.repositoryName) {
            this.recordRule(rule);
        }
    }
    finalReport() {
        for (const name of this.unresolved) {
            console.warn(
                chalk.redBright(
                    "[Unresolved]  ",
                    name,
                    "is referenced but could not be found"
                )
            );
        }
        for (const name of this.unused) {
            console.warn(
                chalk.yellowBright(
                    "[Unresolved]  ",
                    name,
                    "is named but is not used"
                )
            );
        }
        console.log();
        return this.unresolved.length == 0;
    }
}

module.exports = new Unresolved();
