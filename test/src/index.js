const path = require("path");
const fs = require("fs");
const glob = require("glob");
const runTest = require("./testRunner");

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
    // filter for fixtures with a spec
    .filter(test => fs.existsSync(test.spec));

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
