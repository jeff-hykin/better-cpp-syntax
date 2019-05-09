// sort-specs reads the spec files, sorts the keys and remakes them.
// this is not a fixture guided transformation and this has no bearing on wether or not
// a test passes, this also

const path = require("path");
const fs = require("fs");
const yaml = require("js-yaml");

const argv = require("../arguments");
const paths = require("../paths");

const tests = require("../getTests")(test => {
    const result =
        fs.existsSync(test.spec.yaml) ||
        fs.existsSync(test.spec.json) ||
        argv._.length !== 0;
    return result;
});

sortSpecs();
async function sortSpecs() {
    for (const test of tests) {
        console.log(
            "sorting spec for",
            path.relative(paths.fixtureDir, test.fixture)
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
