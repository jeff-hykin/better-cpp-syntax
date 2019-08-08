// stores record results for patterns
const jsonSourceMap = require("json-source-map");

let recorders = {};
let reporters = [];

class recorder {
    /**
     * @typedef {{source: string, count: number[], sumTime: number[]}} Coverage
     */
    constructor(grammar, scopeName) {
        // converts a grammar into a list of pointers which become an array of coverage objects
        const pointers = jsonSourceMap.parse(grammar).pointers;
        /**
         * @type {{[source: string]: Coverage}}
         */
        this.coverage = [];
        this.scopeName = scopeName;
        this.empty = true;
        for (const pointer of Object.keys(pointers)) {
            if (/(?:match|begin|end|while)$/.test(pointer)) {
                const source =
                    scopeName + ":" + (pointers[pointer].key.line + 1);
                this.coverage[source] = {
                    source,
                    // order is failure, unchosen, chosen
                    count: [0, 0, 0],
                    sumTime: [0, 0, 0]
                };
            }
        }
    }
    record(source, time, chosen, failure, onlyPattern) {
        this.empty = false;
        const index = failure ? 0 : chosen ? 2 : 1;
        this.coverage[source].count[index] += 1;
        this.coverage[source].sumTime[index] += time;
        if (onlyPattern && chosen) {
            this.coverage[source].count[1] += 1;
            this.coverage[source].sumTime[1] += time;
        }
    }
    report() {
        for (const reporter of reporters) {
            reporter(this.scopeName, this.coverage);
        }
    }
    isEmpty() {
        return this.empty;
    }
}

module.exports = {
    loadRecorder: function(grammar, scopeName) {
        if (recorders[scopeName]) {
            return;
        }
        recorders[scopeName] = new recorder(grammar, scopeName);
    },
    loadReporter: function(reporter) {
        reporters.push(reporter);
    },
    getRecorder: function(scopeName) {
        return recorders[scopeName];
    },
    reportAllRecorders: function() {
        for (const recorder of Object.values(recorders)) {
            if (!recorder.isEmpty()) {
                recorder.report();
            }
        }
    }
};
