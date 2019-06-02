const _ = require("lodash");

module.exports = function(scopeName, coverage) {
    let averages = [0, 0, 0];
    let notConsidered = 0;
    for (const cov of Object.values(coverage)) {
        if (cov.count[0] > 0) {
            averages[0] += 1;
        }
        // if the recorded pattern is the only pattern in the set, don't count matched unChosen against it
        if (cov.count[1] > 0) {
            averages[1] += 1;
        }
        if (cov.count[2] > 0) {
            averages[2] += 1;
        }
        if (_.every(cov.count, v => v === 0)) {
            notConsidered += 1;
        }
    }
    const totalPatterns = Object.keys(coverage).length;
    averages[0] /= totalPatterns;
    averages[1] /= totalPatterns;
    averages[2] /= totalPatterns;
    console.log(
        "code coverage for %s:\n\t%f%% / %f%% / %f%% / %f%%\n\t(match failure / match not chosen / match chosen / average)",
        scopeName,
        (averages[0] * 100).toFixed(2),
        (averages[1] * 100).toFixed(2),
        (averages[2] * 100).toFixed(2),
        (_.mean(averages) * 100).toFixed(2)
    );
    console.log(
        "\t%d (%f%%) patterns were never considered",
        notConsidered,
        ((notConsidered / totalPatterns) * 100).toFixed(2)
    );
};
