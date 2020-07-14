// generates spec files for fixtures that are missing them

const path = require("path");
const fs = require("fs");
const yaml = require("js-yaml");

const generateSpec = require("../generate_spec");
const pathFor = require("../paths");

const allTests = require("../get_tests");

async function generateSpecs(yargs) {
    // either get all tests, or only the ones that are mentioned
    if (yargs.all) {
        // dont filter any test
        testFilter = (_) => true;
    } else {
        // only pick files that match one of the user-provided arguments
        testFilter = (eachTest) => {
            for (const arg of yargs.fixtures) {
                if (eachTest.fixturePath.match(arg)) {
                    return true;
                }
            }
            return false;
        };
    }
    let tests = allTests.filter(testFilter);

    for (const test of tests) {
        const fixturePath = test.fixturePath;
        console.log(
            "generating spec for",
            path.relative(pathFor.fixtures, fixturePath)
        );
        const fixtureLines = fs
            .readFileSync(fixturePath)
            .toString()
            .split("\n");

        const spec = await generateSpec(fixturePath, fixtureLines);
        fs.writeFileSync(
            test.spec.yaml,
            yaml.dump(JSON.parse(JSON.stringify(spec)), {
                sortKeys: keyCompare,
            })
        );
    }
}

function keyCompare(key1, key2) {
    const order = ["source", "scopesBegin", "scopes", "scopesEnd"];
    return order.indexOf(key1) - order.indexOf(key2);
}

module.exports = {
    command: "generate-specs [fixtures..]",
    desc: "(re)generate spec files",
    builder: (yargs) => {
        yargs.positional("fixtures", {
            default: [],
            describe: "the fixtures to use",
        });
    },
    handler: (yargs) => generateSpecs(yargs),
};
