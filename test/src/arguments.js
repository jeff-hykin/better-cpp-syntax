module.exports = require("yargs")
    .usage("Usage: $0 [options] [fixture]")
    .wrap(require("yargs").terminalWidth())
    .demandCommand(0)
    .option("color", {
        default: true,
        describe: "enable color",
        type: "boolean"
    })
    .nargs("color", 0)
    .option("--generate-all", {
        default: false,
        describe: "generate spec files for all fixtures",
        type: "boolean"
    })
    .option("header-c", {
        default: false,
        type: "boolean",
        describe: "treat .h as source.c"
    })
    .option("coverage", {
        default: false,
        type: "boolean",
        describe: "display the code coverage on running a test"
    })
    .strict()
    .example("$0 issues/002.cpp").argv;
