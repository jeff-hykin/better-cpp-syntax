const path = require("path");
const fs = require("fs");
const util = require("util");
const glob = require("glob");
const vsctm = require("vscode-textmate");
const runTest = require("./testRunner");

const readFile = util.promisify(fs.readFile);

const testDir = path.dirname(__dirname);
const fixtureDir = path.join(testDir, "fixtures");
const specDir = path.join(testDir, "specs");

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
    // filter for fixtures with a spec
    .filter(test => fs.existsSync(test.spec));

// load the grammars
const registry = new vsctm.Registry({
    loadGrammar: scopeName => {
        let grammarPath = "";
        switch (scopeName) {
            case "source.cpp":
                grammarPath = path.join(
                    testDir,
                    "../syntaxes",
                    "cpp.tmLanguage.json"
                );
                break;
            case "source.c":
                grammarPath = path.join(
                    testDir,
                    "../syntaxes",
                    "c.tmLanguage.json"
                );
                break;
            default:
                return Promise.reject("requested non c/c++ grammar");
        }
        return Promise.resolve(
            vsctm.parseRawGrammar(fs.readFileSync(grammarPath), grammarPath)
        );
    }
});

// and run the tests, is in 2 parts to allow async
runTests();
async function runTests() {
    let totalResult = true;
    for (const test of tests) {
        console.log(
            "running test for",
            path.relative(fixtureDir, test.fixture)
        );
        const fixture = fs
            .readFileSync(test.fixture)
            .toString()
            .split("\n");
        const spec = fs.readFileSync(test.spec);
        const result = await runTest(
            registry,
            test.fixture,
            fixture,
            JSON.parse(spec)
        );
        totalResult = result ? totalResult : result;
    }
    process.exit(totalResult ? 0 : 1);
}
