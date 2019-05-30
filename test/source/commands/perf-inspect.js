const path = require("path");
const fs = require("fs");

const yaml = require("js-yaml");

const getTokens = require("../get_tokens");
const argv = require("../arguments");
const paths = require("../paths");

const registry = require("../registry").getRegistry(
    require("../perf_inspect/oniguruma_decorator").getOniguruma
);
const perf = require("../perf_inspect/perf_inspect");

collectPerfInfo();
async function collectPerfInfo() {
    let totalResult = true;
    for (const test of argv._) {
        const fixture = fs
            .readFileSync(test)
            .toString()
            .split("\n");
        await getTokens(registry, test, fixture, () => true);
    }
    console.log();
    perf.reportAllRecorders();
    process.exit(totalResult ? 0 : 1);
}
