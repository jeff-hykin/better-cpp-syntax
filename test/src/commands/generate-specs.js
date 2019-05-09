// generates spec files for fixtures that are missing them

const path = require("path");
const fs = require("fs");
const yaml = require("js-yaml");
const stringify = require("json-stable-stringify");

const argv = require("../arguments");
const generateSpec = require("../generateSpec");
const paths = require("../paths");

const tests = require("../getTests")(test => {
    const result =
        (!fs.existsSync(test.spec.yaml) && !fs.existsSync(test.spec.json)) ||
        argv["generate-all"] ||
        argv._.length !== 0;
    return result;
});

// and generate the specs
generateSpecs();
async function generateSpecs() {
    for (const test of tests) {
        console.log(
            "generating spec for",
            path.relative(paths.fixtureDir, test.fixture)
        );
        const fixture = fs
            .readFileSync(test.fixture)
            .toString()
            .split("\n");

        const spec = await generateSpec(test.fixture, fixture);
        fs.writeFileSync(
            test.spec.yaml,
            yaml.dump(JSON.parse(JSON.stringify(spec)), {
                sortKeys: keyCompare
            })
        );
    }
}

function keyCompare(key1, key2) {
    const order = ["source", "scopesBegin", "scopes", "scopesEnd"];
    return order.indexOf(key1.key) > order.indexOf(key2.key) ? 1 : -1;
}
