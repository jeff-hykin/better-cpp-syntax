const yargs = require("yargs");
let argv = null;

function parseArgs() {
    argv = yargs
        //.scriptName("test/index.js")
        .wrap(yargs.terminalWidth())
        .commandDir("commands")
        // --color is parsed by chalk
        .option("color", {
            default: true,
            describe: "enable color",
            type: "boolean",
            global: true
        })
        .nargs("color", 0)
        .option("all", {
            default: false,
            describe: "run for all fixtures",
            type: "boolean",
            global: true
        })
        .option("header-c", {
            default: false,
            type: "boolean",
            describe:
                "treat .h as source.c (vscode by default treats .h files as source.cpp)",
            global: true
        })
        .strict()
        .example("$0 issues/002.cpp").argv;
}

module.exports = {
    getArgs: () => {
        if (argv === null) {
            parseArgs();
        }
        return argv;
    },
    parseArgs: parseArgs
};
