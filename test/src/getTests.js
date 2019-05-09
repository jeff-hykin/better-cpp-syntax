const path = require("path");
const glob = require("glob");

const argv = require("./arguments");
const paths = require("./paths");

/**
 * @typedef {{fixture: string, spec: string}} Test
 * @param {(test: Test) => boolean} predicate
 * @returns {Test[]}
 */
module.exports = function(predicate) {
    // grab all fixtures
    const fixtures = glob.sync(
        path.join(paths.fixtureDir, "**/*.{c,cc,cxx,cpp,h,hh,hxx,hpp}")
    );
    // and grab the specs
    const tests = fixtures
        .map(fixture => {
            return {
                fixture,
                spec: fixture.replace(paths.fixtureDir, paths.specDir) + ".json"
            };
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
