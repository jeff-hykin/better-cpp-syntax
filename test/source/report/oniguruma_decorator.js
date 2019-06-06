// This file wraps an IOnigLib and collects information to provide pattern coverage statistics
const onigLibs = require("vscode-textmate");
const OnigScanner = require("./onig_scanner");
const recorder = require("./recorder");

// from vscode-textmate src/onigLibs.ts
let onigurumaLib = null;
function getOniguruma() {
    if (!onigurumaLib) {
        let getOnigModule = (function() {
            var onigurumaModule = null;
            return function() {
                if (!onigurumaModule) {
                    onigurumaModule = require("oniguruma");
                }
                return onigurumaModule;
            };
        })();
        onigurumaLib = Promise.resolve({
            createOnigScanner(patterns) {
                let onigurumaModule = getOnigModule();
                return new onigurumaModule.OnigScanner(patterns);
            },
            createOnigString(s) {
                let onigurumaModule = getOnigModule();
                let string = new onigurumaModule.OnigString(s);
                string.content = s;
                return string;
            }
        });
    }
    return onigurumaLib;
}

module.exports = {
    /**
     * @returns {onigLibs.Thenable<onigLibs.IOnigLib>}
     */
    getOniguruma: async function() {
        const oniguruma = await getOniguruma();
        return {
            /**
             * @param {string[]} patterns
             */
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
            /**
             * @param {string} s
             */
            createOnigString: s => {
                return oniguruma.createOnigString(s);
            }
        };
    }
};
