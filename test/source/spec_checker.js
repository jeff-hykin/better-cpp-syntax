const _ = require("lodash");
const chalk = require("chalk");
const vsctm = require("vscode-textmate");
const {removeScopeName} = require("./utils")

/**
 * @typedef {{source: string, scopesBegin: string[], scopes: string[], scopesEnd: string[]}} Spec
 */

module.exports["SpecChecker"] = class SpecChecker {
    constructor(spec, showFailureOnly=false) {
        /**
         * @type {Spec[]}
         */
        this.Specs = spec;
        if (this.Specs[0].c !== undefined) {
            this.Specs = this.convertVSCodeFixtures(this.Specs);
        }
        /**
         * @type {string[]}
         */
        this.scopeStack = new Array("source");
        /**
         * @type {bool}
         */
        this.showFailureOnly = showFailureOnly;
    }
    /**
     * @param {string} line
     * @param {vsctm.IToken} token
     */
    checkToken(line, token) {
        // process zero width scope changes
        while (
            this.Specs.length > 0 &&
            (this.Specs[0].source === undefined || this.Specs[0].source === "")
        ) {
            this.getScopes(this.Specs.shift());
        }
        const source = line.substring(token.startIndex, token.endIndex);
        // ignore empty tokens
        if (source.trim() === "") {
            return true;
        }
        if (this.Specs.length === 0) {
            this.showFailureOnly || console.error("ran out of specs");
            return false;
        }
        const spec = this.Specs.shift();
        if (source !== spec.source) {
            this.showFailureOnly || console.error(
                "spec mismatch: next token is |%s| but spec has |%s|",
                source,
                spec.source
            );
            return false;
        }
        let specScopes = this.getScopes(spec);
        let tokenScopes = token.scopes.map(removeScopeName);
        // remove the source tags from both
        specScopes = specScopes.filter(each => each != "source")
        tokenScopes = tokenScopes.filter(each => each != "source")
        if (_.isEqual(specScopes, tokenScopes)) {
            return true;
        }
        this.showFailureOnly || console.group("scope mismatch: token |%s| has wrong scope", source);
        this.showFailureOnly || console.log();
        this.showFailureOnly || console.group("scopes in spec");
        for (const scope of specScopes) {
            this.displayScope(scope, tokenScopes, specScopes);
        }
        this.showFailureOnly || console.groupEnd();
        this.showFailureOnly || console.log();
        this.showFailureOnly || console.group("actual scopes");
        for (const scope of tokenScopes) {
            this.displayScope(scope, tokenScopes, specScopes);
        }
        this.showFailureOnly || console.log();
        this.showFailureOnly || console.groupEnd();
        this.showFailureOnly || console.groupEnd();
        return false;
    }

    displayScope(scope, newScopes, oldScopes) {
        if (_.includes(newScopes, scope) && !_.includes(oldScopes, scope)) {
            this.showFailureOnly || console.log(chalk.greenBright("+ " + scope));
        } else if (
            !_.includes(newScopes, scope) &&
            _.includes(oldScopes, scope)
        ) {
            this.showFailureOnly || console.log(chalk.redBright("- " + scope));
        } else this.showFailureOnly || console.log(chalk.whiteBright("  " + scope));
    }

    /**
     * @param {Spec} spec
     * @return {string[]}
     */
    getScopes(spec) {
        if (spec.scopesBegin !== undefined) {
            for (const scope of spec.scopesBegin) {
                this.scopeStack.push(scope);
            }
        }
        const specScopes = [...this.scopeStack, ...(spec.scopes || [])].map(
            removeScopeName
        );
        if (spec.scopesEnd) {
            for (const scope of spec.scopesEnd.reverse()) {
                if (this.scopeStack[this.scopeStack.length - 1] !== scope) {
                    console.error(
                        "attempted to pop %s off scope stack, top of stack is %s",
                        scope,
                        this.scopeStack[this.scopeStack.length - 1]
                    );
                }
                this.scopeStack.pop();
            }
        }
        return specScopes;
    }

    /**
     * converts vscode style fixtures (c,t,r) to specs
     * @param {any} fixtures
     * @returns {Spec[]}
     */
    convertVSCodeFixtures(fixtures) {
        return fixtures
            .filter(f => f.c.trim() !== "")
            .map(f => {
                // return if in correct spec style
                if (f.scopes) return f;
                const scopes = _.tail(f.t.split(" "));
                // f is spread back in to allow for gradual replacement
                return { source: f.c, scopes, ...f };
            });
    }
};
