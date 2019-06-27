const fs = require("fs")
const glob = require("glob")
const path = require("path")
const _ = require("lodash")

const getTokens = require("../get_tokens")
const argv = require("../arguments")
const { getOniguruma } = require("../report/oniguruma_decorator")
const { getRegistry } = require("../registry")
const recorder = require("../report/recorder")
const {performanceForEachFixture, currentActiveFixture} = require("../symbols")

const registry = getRegistry(getOniguruma)
// get all reporters
let reporters = {}
for (const each of glob.sync(`${__dirname}/../report/reporters/*.js`)) {
    let filename = path.basename(each).replace(/\.js$/, "")
    reporters[filename] = require(each)
}

//
// Commandline args
//
let [reporterName, ...files] = argv._

// load the one mentioned in the commandline
recorder.loadReporter(reporters[reporterName])
// if no files mentioned, then use all the fixtures
if (files.length === 0) {
    // use text fixtures instead
    files = require("../get_tests")().map(test => test.fixture)
}

collectRecords()
async function collectRecords() {
    global[performanceForEachFixture] = {}
    for (const eachFile of files) {
        console.log(eachFile)
        global[currentActiveFixture] = eachFile
        const fixture = fs
            .readFileSync(eachFile)
            .toString()
            .split("\n")
        await getTokens(registry, eachFile, fixture, false, () => true)
    }
    console.log();
    recorder.reportAllRecorders()
}