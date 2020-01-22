const path = require("path");
const glob = require("glob");
const fs = require("fs");

const pathFor = require("./paths");

/**
 * @typedef {{fixture: string, spec: {json: string, yaml: string, default: string}}} Test
 * @param {(test: Test) => boolean} predicate
 * @returns {Test[]}
 */
module.exports = (yargs, testFilter = _each => true) =>
    pathFor.eachFixture
        .map(fixturePath => {
            let specPath = fixturePath.replace(/\.[^.]+/, ".spec.yaml")
            return {
                fixturePath,
                spec: {
                    yaml: specPath,
                    default: specPath
                }
            };
        })
        .filter(
            test =>
                testFilter(test) &&
                (yargs.fixtures.length == 0 ||
                    yargs.fixtures.includes(
                        path.relative(pathFor.fixtures, test.fixturePath)
                    ))
        );
