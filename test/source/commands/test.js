const path = require("path");
const fs = require("fs");

const yaml = require("js-yaml");

const runTest = require("../test_runner");
const argv = require("../arguments");
const paths = require("../paths");

const registry = require("../registry").getRegistry(
    argv.coverage
        ? require("../pattern_coverage/oniguruma_decorator").getOniguruma
        : undefined
);
const coverage = require("../pattern_coverage/pattern_coverage");

const tests = require("../get_tests")(
    test =>
        argv._.length == 0 ||
        argv._.includes(path.relative(paths.fixtureDir, test.fixture))
);

// and run the tests, is in 2 parts to allow async
runTests();
async function runTests() {
    let totalResult = true;
    for (const test of tests) {
        console.group(
            "running test for",
            path.relative(paths.fixtureDir, test.fixture)
        );
        const fixture = fs
            .readFileSync(test.fixture)
            .toString()
            .split("\n");
        const spec = fs.readFileSync(test.spec.default);
        const result = await runTest(
            registry,
            path.relative(paths.fixtureDir, test.fixture),
            fixture,
            yaml.safeLoad(spec, { filename: test.spec.default, json: true })
        );
        totalResult = result ? totalResult : result;
        console.groupEnd();
    }
    console.log();
    coverage.reportAllRecorders();
    process.exit(totalResult ? 0 : 1);
}
