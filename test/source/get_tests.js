const path = require("path")
const glob = require("glob")
const fs = require("fs")

const argv = require("./arguments")
const pathFor = require("./paths")

/**
 * @typedef {{fixture: string, spec: {json: string, yaml: string, default: string}}} Test
 * @param {(test: Test) => boolean} predicate
 * @returns {Test[]}
 */
module.exports = (testFilter = each => true) =>
    pathFor.eachFixture
        .map(fixture => {
            let specPath = fixture.replace(pathFor.fixtures, pathFor.specDir)
            return {
                fixture,
                spec: {
                    json: `${specPath}.json`,
                    yaml: `${specPath}.yaml`,
                    // use json if yaml doesn't exist
                    default: fs.existsSync(`${specPath}.yaml`) ? `${specPath}.yaml` : `${specPath}.yaml`,
                },
            }
        })
        .filter(test => testFilter(test) && (argv._.length == 0 || argv._.includes(path.relative(pathFor.fixtures, test.fixture))))
