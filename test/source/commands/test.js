const path = require("path");
const fs = require("fs");

const yaml = require("js-yaml");

const runTest = require("../test_runner");
const argv = require("../arguments");
const pathFor = require("../paths");

const registry = require("../registry").default;

const tests = require("../get_tests")(
    test =>
        argv._.length == 0 ||
        argv._.includes(path.relative(pathFor.fixtures, test.fixture))
);

// and run the tests, is in 2 parts to allow async
runTests();
async function runTests() {
    let totalResult = true;
    for (const test of tests) {
        console.group(
            "running test for",
            path.relative(pathFor.fixtures, test.fixture)
        );
        const fixture = fs
            .readFileSync(test.fixture)
            .toString()
            .split("\n");
        const spec = fs.readFileSync(test.spec.default);
        const result = await runTest(
            registry,
            path.relative(pathFor.fixtures, test.fixture),
            fixture,
            yaml.safeLoad(spec, { filename: test.spec.default, json: true }),
            argv["show-failure-only"]
        );
        totalResult = result ? totalResult : result;
        console.groupEnd();
    }
    console.log();
    process.exit(totalResult ? 0 : 1);
}
