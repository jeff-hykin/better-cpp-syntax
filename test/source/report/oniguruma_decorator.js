// This file wraps an IOnigLib and collects information to provide pattern coverage statistics
const onigLibs = require("vscode-textmate");
const OnigScanner = require("./onig_scanner");
const recorder = require("./recorder");
const fs = require("fs");
const path = require("path");

// from vscode-textmate src/tests/onigLibs.ts
let vscodeOnigurumaLib = null;
function getVSCodeOniguruma() {
    if (!vscodeOnigurumaLib) {
        let vscodeOnigurumaModule = require("vscode-oniguruma");
        // load wasm file from node_modules
        const wasm = fs.readFileSync(
            path.join(
                __dirname,
                "../../..",
                "node_modules",
                "vscode-oniguruma/release/onig.wasm"
            )
        ).buffer;
        vscodeOnigurumaLib = vscodeOnigurumaModule.loadWASM(wasm).then(() => {
            return {
                createOnigScanner(patterns) {
                    return new vscodeOnigurumaModule.OnigScanner(patterns);
                },
                createOnigString(s) {
                    return new vscodeOnigurumaModule.OnigString(s);
                },
            };
        });
    }
    return vscodeOnigurumaLib;
}

module.exports = {
    /**
     * @returns {onigLibs.Thenable<onigLibs.IOnigLib>}
     */
    getOniguruma: async function () {
        const oniguruma = await getVSCodeOniguruma();
        return {
            /**
             * @param {string[]} patterns
             */
            createOnigScanner: (patterns) => {
                if (patterns.length === 0) {
                    return new OnigScanner(patterns, undefined);
                }
                // grab scopeName from first pattern
                const scopeName = patterns[0].match(
                    /^\(\?#(source\..+):\d+\)/
                )[1];
                return new OnigScanner(
                    patterns,
                    recorder.getRecorder(scopeName),
                    oniguruma.createOnigScanner
                );
            },
            /**
             * @param {string} s
             */
            createOnigString: (s) => {
                return oniguruma.createOnigString(s);
            },
        };
    },

    getDefaultOniguruma: async function () {
        return await getVSCodeOniguruma();
    },
};
