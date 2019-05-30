// stores coverage results for grammars
const jsonSourceMap = require("json-source-map");
const _ = require("lodash");

class perfInspect {
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
        this.totalTime = 0;
        for (const pointer of Object.keys(pointers)) {
            if (/(?:match|begin|end|while)$/.test(pointer)) {
                const source = scopeName + ":" + pointers[pointer].key.line;
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
        this.totalTime += time;
    }
    report() {
        const labels = [
            "match failure",
            "matched, not chosen",
            "matched, chosen"
        ];
        for (let i = 0; i < 3; i += 1) {
            console.log(labels[i]);
            console.log("pattern         \t average time \t total time");
            let keys = Object.keys(this.coverage).filter(
                k =>
                    this.coverage[k].count[i] > 0 &&
                    this.coverage[k].sumTime[i] > 0
            );
            keys = _.sortBy(
                keys,
                k => -(this.coverage[k].sumTime[i] / this.coverage[k].count[i])
            );
            for (const k of keys) {
                console.log(
                    this.coverage[k].source,
                    " ",
                    "\t",
                    this.coverage[k].sumTime[i] / this.coverage[k].count[i],
                    "\t",
                    this.coverage[k].sumTime[i]
                );
            }
        }
    }
    isEmpty() {
        return this.empty;
    }
}

let recorders = {};

module.exports = {
    loadRecorder: function(grammar, scopeName) {
        if (recorders[scopeName]) {
            return;
        }
        recorders[scopeName] = new perfInspect(grammar, scopeName);
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
