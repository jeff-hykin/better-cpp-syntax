// sort-specs reads the spec files, sorts the keys and remakes them.
// this is not a fixture guided transformation and this has no bearing on wether or not
// a test passes, this also

const path = require("path");
const fs = require("fs");
const yaml = require("js-yaml");

const pathFor = require("../paths");

async function sortSpecs(yargs) {
    const tests = require("../get_tests")(yargs, test => {
        const result =
            fs.existsSync(test.spec.yaml) ||
            fs.existsSync(test.spec.json) ||
            yargs.fixtures.length !== 0;
        return result;
    });

    for (const test of tests) {
        console.log(
            "sorting spec for",
            path.relative(pathFor.fixtures, test.fixture)
        );

        const spec = fs.readFileSync(test.spec.default);
        fs.writeFileSync(
            test.spec.yaml,
            yaml.dump(yaml.safeLoad(spec), {
                sortKeys: keyCompare
            })
        );
    }
}

function keyCompare(key1, key2) {
    const order = ["source", "scopesBegin", "scopes", "scopesEnd"];
    return order.indexOf(key1) - order.indexOf(key2);
}

module.exports = {
    command: "sort-specs [fixtures..]",
    desc: "sort spec files",
    handler: yargs => sortSpecs(yargs)
};
