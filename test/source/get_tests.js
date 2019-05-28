const path = require("path");
const glob = require("glob");
const fs = require("fs");

const argv = require("./arguments");
const paths = require("./paths");

/**
 * @typedef {{fixture: string, spec: {json: string, yaml: string, default: string}}} Test
 * @param {(test: Test) => boolean} predicate
 * @returns {Test[]}
 */
module.exports = function(predicate) {
    // grab all fixtures
    const fixtures = glob.sync(
        path.join(
            paths.fixtureDir,
            "**/*.{c,C,cc,cxx,cpp,h,hh,hxx,hpp,m,M,mm,x,xh,xmi}"
        )
    );
    // and grab the specs
    const tests = fixtures
        .map(fixture => {
            return {
                fixture,
                spec: {
                    json:
                        fixture.replace(paths.fixtureDir, paths.specDir) +
                        ".json",
                    yaml:
                        fixture.replace(paths.fixtureDir, paths.specDir) +
                        ".yaml",
                    default:
                        fixture.replace(paths.fixtureDir, paths.specDir) +
                        ".yaml"
                }
            };
        })
        .map(test => {
            // use json if yaml doesn't exist
            if (!fs.existsSync(test.spec.yaml)) {
                test.spec.default = test.spec.json;
            }
            return test;
        })
        // filter for fixtures with a spec
        .filter(predicate)
        .filter(
            test =>
                argv._.length == 0 ||
                argv._.includes(path.relative(paths.fixtureDir, test.fixture))
        );
    return tests;
};
