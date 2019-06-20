const fs = require("fs");
const _ = require("lodash");

const getTokens = require("../get_tokens");
const argv = require("../arguments");
const registry = require("../registry").getRegistry(
    require("../report/oniguruma_decorator").getOniguruma
);

const recorder = require("../report/recorder");
const reporters = {
    coverage: require("../report/reporters/coverage"),
    perf: require("../report/reporters/perf")
};

let files = _.tail(argv._);
if (files.length === 0) {
    // use text fixtures instead
    files = require("../get_tests")().map(test => test.fixture);
}

recorder.loadReporter(reporters[argv._[0]]);

collectRecords();
async function collectRecords() {
    let totalResult = true;
    for (const test of files) {
        console.log(test);
        const fixture = fs
            .readFileSync(test)
            .toString()
            .split("\n");
        await getTokens(registry, test, fixture, false, () => true);
    }
    console.log();
    recorder.reportAllRecorders();
    process.exit(totalResult ? 0 : 1);
}
