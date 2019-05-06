// generates spec files for fixtures that are missing them

const path = require("path");
const fs = require("fs");
const glob = require("glob");
const argv = require("yargs").argv;
const _ = require("lodash");

const getTokens = require("./getTokens");

const testDir = path.dirname(__dirname);
const fixtureDir = path.join(testDir, "fixtures");
const specDir = path.join(testDir, "specs");

const registry = require("./registry");

// grab all fixtures
const fixtures = glob.sync(
    path.join(fixtureDir, "**/*.{c,cc,cxx,cpp,h,hh,hxx,hpp}")
);
// and grab the specs
const tests = fixtures
    .map(fixture => {
        return {
            fixture,
            spec: fixture.replace(fixtureDir, specDir) + ".json"
        };
    })
    // filter for fixtures without a spec, or all if so asked
    .filter(test => !fs.existsSync(test.spec) || argv["generate-all"]);

// and generate the specs
generateSpecs();
async function generateSpecs() {
    for (const test of tests) {
        console.log(
            "generating spec for",
            path.relative(fixtureDir, test.fixture)
        );
        const fixture = fs
            .readFileSync(test.fixture)
            .toString()
            .split("\n");

        const spec = await generateSpec(test.fixture, fixture);
        fs.writeFileSync(test.spec, JSON.stringify(spec, null, 4));
    }
}

async function generateSpec(path, fixture) {
    let spec = [];
    await getTokens(registry, path, fixture, (line, token) => {
        const source = line.substring(token.startIndex, token.endIndex);
        if (source.trim() === "") {
            return true;
        }
        const scopes = token.scopes.filter(s => s.indexOf("source.c") !== 0);
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
            for (let scope of scopeStack) {
                if (scope !== next.scopes[nextIndex]) {
                    scopesEnd.push(scope);
                }
                nextIndex += 1;
            }
            if (scopesEnd.length) {
                object.scopesEnd = scopesEnd;
                object.scopes = _.difference(object.scopes, scopesEnd);
                for (let scope of scopesEnd.slice().reverse()) {
                    if (scope === scopeStack[scopeStack.length - 1]) {
                        scopeStack.pop();
                    }
                }
            }
        }
        object.scopes = _.difference(object.scopes, scopeStack);
    }
    return spec;
}
