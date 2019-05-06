const _ = require("lodash");
const vsctm = require("vscode-textmate");

/**
 * @typedef {{source: string, scopesBegin: string[], scopes: string[], scopesEnd: string[]}} Spec
 */

function removeScopeName(scope) {
    return scope.replace(/\.c(pp)?$/, "");
}

module.exports["SpecChecker"] = class SpecChecker {
    constructor(spec) {
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
            console.error("ran out of specs");
            return false;
        }
        const spec = this.Specs.shift();
        if (source !== spec.source) {
            console.error(
                "spec mismatch: next token is |%s| but spec has |%s|",
                source,
                spec.source
            );
            return false;
        }
        const specScopes = this.getScopes(spec);
        const tokenScopes = token.scopes.map(removeScopeName);
        if (_.isEqual(specScopes, tokenScopes)) {
            return true;
        }
        console.error("scope mismatch: token |%s| has wrong scope", source);
        console.group("scopes in spec");
        for (const scope of specScopes) {
            console.log(scope);
        }
        console.groupEnd();
        console.group("actual scopes");
        for (const scope of tokenScopes) {
            console.log(scope);
        }
        console.groupEnd();
        return false;
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
        return fixtures.map(f => ({ source: f.c, scopes: f.t }));
    }
};
