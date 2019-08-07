// this files acts like a onigScanner except that it checks each pattern in turn to
// determine which pattern actually matched.
// it also double checks with an actual onigScanner
const vsctm = require("vscode-textmate");
const oniguruma = require("oniguruma");
const { performance } = require("perf_hooks");

module.exports = class OnigScanner {
    /**
     * @param {string[]} patterns
     */
    constructor(patterns, recorder) {
        this.onigScanner = new oniguruma.OnigScanner(patterns);
        this.regexps = patterns.map(
            pattern => new oniguruma.OnigRegExp(pattern)
        );
        this.patterns = patterns;
        this.recorder = recorder;
    }
    /**
     * @param {string} string
     * @param {number} startPosition
     * @returns {vsctm.IOnigMatch}
     */
    findNextMatchSync(string, startPosition = 0) {
        /**
         * @typedef {{line: string, matchTime: number, match: object, chosen: boolean}} Result
         * @type {Result}
         */
        let results = [];
        // construct a list of result objects
        for (const [index, value] of this.regexps.entries()) {
            const startTime = performance.now();
            const match = value.searchSync(string.toString(), startPosition);
            const endTime = performance.now();
            try {
                results.push({
                    match,
                    matchTime: endTime - startTime,
                    line: this.patterns[index].match(
                        /^\(\?#(source\..+:\d+)\)/
                    )[1],
                    chosen: false // chosen is calculated after the fact
                });
            } catch (e) {
                console.log(this.patterns[index]);
            }
            if (match && match[0].start == startPosition) {
                break;
            }
        }
        // chose the best match
        // best match means the match with the earliest starting position for the 0th sub-expression
        // for two equally good choices, pick the first
        // see https://github.com/atom/node-oniguruma/blob/master/src/onig-searcher.cc
        /**
         * @type {Result}
         */
        let chosenResult = results[0];
        for (const result of results) {
            if (result.match) {
                if (
                    chosenResult.match === null ||
                    result.match[0].start < chosenResult.match[0].start
                ) {
                    chosenResult = result;
                }
            }
        }
        if (chosenResult) {
            chosenResult.chosen = true;
        }
        //report all results
        for (const result of results) {
            this.recorder.record(
                result.line,
                result.matchTime,
                result.chosen,
                result.match === null,
                this.patterns.length === 1
            );
        }
        // use a genuine OnigScanner return as the result format is slightly different
        return this.onigScanner.findNextMatchSync(string, startPosition);
    }
};
