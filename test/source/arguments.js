module.exports = require("yargs")
    .usage("Usage: $0 [options] [fixture]")
    .wrap(require("yargs").terminalWidth())
    .demandCommand(0)
    // --color is parsed by chalk
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
    .option("perf-limit", {
        default: 20,
        type: "number",
        describe: "limit the number of perf report lines (0 to disable)"
    })
    .strict()
    .example("$0 issues/002.cpp").argv;
