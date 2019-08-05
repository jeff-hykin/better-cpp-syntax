const path = require("path");
const fs = require("fs");

const yaml = require("js-yaml");

const runTest = require("../test_runner");
const pathFor = require("../paths");

async function runTests(yargs) {
    const registry = require("../registry").default;
    const tests = require("../get_tests")(
        yargs,
        require("../select_tests")(yargs)
    );

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
            yargs.showFailureOnly
        );
        totalResult = result ? totalResult : result;
        console.groupEnd();
    }
    console.log();
    process.exit(totalResult ? 0 : 1);
}

module.exports = {
    command: "test [fixtures..]",
    desc: "run tests",
    builder: yargs => {
        yargs
            .option("show-failure-only", {
                default: false,
                describe: "Only show IF a spec failed, no details",
                type: "boolean"
            })
            .positional("fixtures", {
                default: [],
                describe: "the fixtures to use"
            });
    },
    handler: yargs => runTests(yargs)
};
