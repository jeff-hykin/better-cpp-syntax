// generates spec files for fixtures that are missing them

const path = require("path");
const fs = require("fs");
const glob = require("glob");
const argv = require("yargs").argv;

const getTokens = require("./getTokens");

const testDir = path.dirname(__dirname);
const fixtureDir = path.join(testDir, "fixtures");
const specDir = path.join(testDir, "specs");

const registry = require("./registry");

// grab all fixtures
const fixtures = glob.sync(
    path.join(fixtureDir, "**/*.{c,cc,cxx,cpp,h,hh,hxx,hpp}")
);
// and grab the specs
const tests = fixtures
    .map(fixture => {
        return {
            fixture,
            spec: fixture.replace(fixtureDir, specDir) + ".json"
        };
    })
    // filter for fixtures without a spec, or all if so asked
    .filter(test => !fs.existsSync(test.spec) || argv["generate-all"]);

// and generate the specs
generateSpecs();
async function generateSpecs() {
    for (const test of tests) {
        console.log(
            "generating spec for",
            path.relative(fixtureDir, test.fixture)
        );
        const fixture = fs
            .readFileSync(test.fixture)
            .toString()
            .split("\n");

        const spec = await generateSpec(test.fixture, fixture);
        fs.writeFileSync(test.spec, JSON.stringify(spec, null, 4));
    }
}

async function generateSpec(path, fixture) {
    let spec = [];
    await getTokens(registry, path, fixture, (line, token) => {
        const source = line.substring(token.startIndex, token.endIndex);
        if (source.trim() === "") {
            return true;
        }
        const scopes = token.scopes.filter(s => s.indexOf("source.c") !== 0);
        spec.push({
            source,
            scopes
        });
        return true;
    });
    return spec;
}
