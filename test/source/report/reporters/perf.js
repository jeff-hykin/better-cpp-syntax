const _ = require("lodash");
const chalk = require("chalk");
const argv = require("../../arguments");

const labels = ["match failure", "matched, not chosen", "matched, chosen"];

module.exports = function(scopeName, coverage) {
    for (let i = 0; i < 3; i += 1) {
        console.log(labels[i]);
        console.log(
            "%s   %s    %s",
            "pattern name".padEnd(22),
            "average time",
            "total time"
        );
        let keys = Object.keys(coverage).filter(
            k => coverage[k].count[i] > 0 && coverage[k].sumTime[i] > 0
        );
        keys = _.sortBy(
            keys,
            k => -(coverage[k].sumTime[i] / coverage[k].count[i])
        );
        const avgMax = _.maxBy(
            keys,
            k => coverage[k].sumTime[i] / coverage[k].count[i]
        );
        keys = _.take(keys, argv.getArgs()["perf-limit"]);
        const totalMax = _.maxBy(keys, k => coverage[k].sumTime[i]);
        for (const k of keys) {
            let color =
                k === avgMax || k === totalMax ? chalk.bold : chalk.reset;
            let avgColor = k === avgMax ? chalk.red : chalk.visible;
            let totalColor = k === totalMax ? chalk.yellow : chalk.visible;
            let average = coverage[k].sumTime[i] / coverage[k].count[i];
            console.log(
                color(
                    coverage[k].source.padEnd(22),
                    avgColor(average.toFixed(6).padStart(12)),
                    totalColor(coverage[k].sumTime[i].toFixed(3).padStart(12))
                )
            );
        }
        console.log();
    }
    console.log();
};
