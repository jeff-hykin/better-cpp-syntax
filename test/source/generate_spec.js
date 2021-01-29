const getTokens = require("./get_tokens");
const registry = require("./registry").default;
const _ = require("lodash");
const path = require("path");
const paths = require("./paths");
const { removeScopeName } = require("./utils");

/**
 * @param {string} path
 * @param {string[]} fixture
 */
module.exports = async function generateSpec(path, fixture) {
    let spec = [];
    await getTokens(registry, path, fixture, false, false, (line, token) => {
        const source = line.substring(token.startIndex, token.endIndex);
        if (source.trim() === "") {
            return true;
        }
        const scopes = _.tail(token.scopes).map(removeScopeName);
        spec.push({
            source,
            scopes
        });
        return true;
    });
    // this contains raw scopes, and while that works, generate scopesBegin, scopesEnd
    // can significantly (33%) decrease file size of generated spec files
    // basic plan is for each spec object, compare it and the next:
    //  if the next object is missing a scope on the scope stack, add missing scopes
    //    to scopesEnd
    //  if this and next share a scope that is not on the scope stack
    //    add scopes to scopesBegin
    //  for each scope in scopes, remove if in scopeStack
    /**
     * @type {string[]}
     */
    let scopeStack = [];
    for (let index = 0; index < spec.length; index += 1) {
        let object = spec[index];
        if (index < spec.length - 1) {
            const next = spec[index + 1];
            // determining common initial scope is not quite an intersection so it is done manually
            let common = [];
            for (
                let commonIndex = 0;
                commonIndex <
                Math.min(object.scopes.length, next.scopes.length);
                commonIndex += 1
            ) {
                if (object.scopes[commonIndex] === next.scopes[commonIndex]) {
                    common.push(object.scopes[commonIndex]);
                } else {
                    break;
                }
            }
            if (common.length > scopeStack.length) {
                object.scopesBegin = [];
                for (
                    let index = scopeStack.length;
                    index < common.length;
                    index += 1
                ) {
                    object.scopesBegin.push(common[index]);
                    scopeStack.push(common[index]);
                }
            }
            // add to scopesEnd all scopes that scopeStack has but next does not
            let nextIndex = 0;
            let scopesEnd = [];
            let scopesMatch = true;
            for (let scope of scopeStack) {
                if (scope !== next.scopes[nextIndex] || !scopesMatch) {
                    scopesMatch = false;
                    scopesEnd.push(scope);
                }
                nextIndex += 1;
            }
            if (scopesEnd.length) {
                object.scopesEnd = scopesEnd;
                for (let scope of scopesEnd.slice().reverse()) {
                    if (scope === scopeStack[scopeStack.length - 1]) {
                        scopeStack.pop();
                    } else {
                        console.error(
                            "Expected top of scope stack to be %s, but found %s",
                            scope,
                            scopeStack[scopeStack.length - 1]
                        );
                        console.error(scopesEnd);
                        console.error(object.source, object.scopes);
                        console.error(next.source, next.scopes);
                    }
                }
                let nonLocalScopes = [...scopeStack, ...scopesEnd];
                object.scopes = [
                    ...scopeStack,
                    ...object.scopes.slice(nonLocalScopes.length)
                ];
            }
        }
        object.scopes = object.scopes.slice(scopeStack.length);
        if (object.scopes.length === 0) {
            object.scopes = undefined;
        }
    }
    return spec;
};
