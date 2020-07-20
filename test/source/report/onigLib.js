// This file returns onigLib
const OnigScanner = require("./onig_scanner");
const recorder = require("./recorder");
const oniguruma = require("oniguruma")

module.exports = {
    createOnigScanner: patterns => {
        if (patterns.length === 0) {
            return new OnigScanner(patterns, undefined);
        }
        // grab scopeName from first pattern
        const scopeName = patterns[0].match(
            /^\(\?#(source\..+):\d+\)/
        )[1];
        return new OnigScanner(
            patterns,
            recorder.getRecorder(scopeName)
        );
    },
    createOnigString: (s) => {
        let string = new oniguruma.OnigString(s)
        string.content = s;
        return string;
    }
}