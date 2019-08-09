const fs = require("fs");
const glob = require("glob");
const path = require("path");
const _ = require("lodash");

const getTokens = require("../get_tokens");
const { getOniguruma } = require("../report/oniguruma_decorator");
const { getRegistry } = require("../registry");
const recorder = require("../report/recorder");
const {
    performanceForEachFixture,
    currentActiveFixture
} = require("../symbols");

// get all reporters
let reporters = {};
for (const each of glob.sync(`${__dirname}/../report/reporters/*.js`)) {
    let filename = path.basename(each).replace(/\.js$/, "");
    reporters[filename] = require(each);
}

async function runReport(yargs) {
    const registry = getRegistry(getOniguruma);
    // load the one mentioned in the commandline
    recorder.loadReporter(reporters[yargs.reporter]);

    // if no files mentioned, then use all the fixtures
    let files = yargs.fixtures;
    if (files.length === 0) {
        // use text fixtures instead
        files = require("../get_tests")(yargs).map(test => test.fixture);
    } else {
        files = _.flatten(files.map(file => glob.sync(file)));
    }

    global[performanceForEachFixture] = {};
    for (const eachFile of files) {
        console.log(eachFile);
        global[currentActiveFixture] = eachFile;
        const fixture = fs
            .readFileSync(eachFile)
            .toString()
            .split("\n");
        await getTokens(registry, eachFile, fixture, false, true, () => true);
    }
    console.log();
    recorder.reportAllRecorders();
}

module.exports = {
    command: "report <reporter> [fixtures..]",
    desc: "Runs <reporter> and reports the collected information.",
    builder: yargs => {
        yargs
            .positional("reporter", {
                choices: Object.keys(reporters),
                describe: "the reporter to run"
            })
            .positional("fixtures", {
                default: [],
                describe: "the fixtures to use"
            })
            .option("perf-limit", {
                default: 20,
                type: "number",
                describe: "limit the number of perf report lines (0 to disable)"
            });
    },
    handler: yargs => runReport(yargs)
};
