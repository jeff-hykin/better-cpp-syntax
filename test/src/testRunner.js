const pa = require("path");
const _ = require("lodash");
const vsctm = require("vscode-textmate");
const argv = require("yargs").argv;

/**
 * @param {vsctm.Registry} registry
 * @param {string} path
 * @param {string[]} fixture
 * @param {object} spec
 */
module.exports = async function(registry, path, fixture, spec) {
    try {
        let sourceName = "source.cpp";
        if (
            pa.extname(path) == ".c" ||
            path.includes("/c/") ||
            (argv["header-c"] && pa.extname(path) == ".h")
        ) {
            sourceName = "source.c";
        }
        const grammar = await registry.loadGrammar(sourceName);
        let ruleStack = null;

        const checker = new SpecChecker(spec);

        for (const line of fixture) {
            let r = grammar.tokenizeLine(line, ruleStack);
            ruleStack = r.ruleStack;
            let displayLine = false;
            for (const token of r.tokens) {
                if (!checker.checkToken(line, token)) {
                    displayLine = true;
                }
            }
            if (displayLine) {
                console.log("line was |%s|", line);
            }
        }
    } catch (e) {
        console.error(e);
    }
};

/**
 * @typedef {{source: string, scopesBegin: string[], scopes: string[], scopesEnd: string[]}} Spec
 */

class SpecChecker {
    constructor(spec) {
        /**
         * @type {Spec[]}
         */
        this.Specs = spec;
        /**
         * @type {string[]}
         */
        this.scopeStack = new Array("source");
    }
    removeScopeName(scope) {
        return scope.replace(/\.c(pp)?$/, "");
    }
    /**
     * @param {string} line
     * @param {vsctm.IToken} token
     */
    checkToken(line, token) {
        const source = line.substring(token.startIndex, token.endIndex).trim();
        // ignore empty tokens
        if (source === "") {
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
        if (spec.scopesBegin !== undefined) {
            for (const scope of spec.scopesBegin) {
                this.scopeStack.push(scope);
            }
        }
        const specScopes = [...this.scopeStack, ...(spec.scopes || [])].map(
            this.removeScopeName
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
        const tokenScopes = token.scopes.map(this.removeScopeName);
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
}
