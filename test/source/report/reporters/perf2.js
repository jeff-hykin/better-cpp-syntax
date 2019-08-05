const _ = require("lodash");
const fs = require("fs");
const path = require("path");
const chalk = require("chalk");
const {
    performanceForEachFixture,
    currentActiveFixture
} = require("../../symbols");

const labels = ["match failure", "matched, not chosen", "matched, chosen"];

module.exports = function(scopeName, coverage) {
    for (let i = 0; i < 3; i += 1) {
        let allScopes = [];
        for (const k of Object.keys(coverage)) {
            if (k => coverage[k].count[i] > 0 && coverage[k].sumTime[i] > 0) {
                allScopes.push({
                    source: coverage[k].source,
                    average: coverage[k].sumTime[i] / coverage[k].count[i],
                    total: coverage[k].sumTime[i]
                });
            }
        }

        // get the info for the current fixture
        let currentFixtureRecord =
            global[performanceForEachFixture][global[currentActiveFixture]];
        if (!(currentFixtureRecord instanceof Object)) {
            currentFixtureRecord = {
                maxAverageTime: 0,
                maxTotalTime: 0,
                maxAverageSource: "",
                maxTotalSource: ""
            };
        }
        // update the scope if they're larger
        for (const each of allScopes) {
            if (currentFixtureRecord.maxAverageTime < each.average) {
                currentFixtureRecord.maxAverageSource = each.source;
                currentFixtureRecord.maxAverageTime = each.average;
            }
            if (currentFixtureRecord.maxTotalTime < each.total) {
                currentFixtureRecord.maxTotalSource = each.source;
                currentFixtureRecord.maxTotalTime = each.total;
            }
        }
        // record the performance
        global[performanceForEachFixture][
            global[currentActiveFixture]
        ] = currentFixtureRecord;
    }
    //
    // Save the report
    //
    let report = JSON.parse(fs.readFileSync("report.json", "utf-8"));
    let name = path.basename(global[currentActiveFixture]);
    let folder = path.dirname(global[currentActiveFixture]);
    let folderName = path.basename(folder);
    report[folderName + "/" + name] =
        global[performanceForEachFixture][global[currentActiveFixture]];
    fs.writeFileSync("report.json", JSON.stringify(report));
};
