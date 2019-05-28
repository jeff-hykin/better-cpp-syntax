const getTokens = require("./getTokens");
const SpecChecker = require("./specChecker").SpecChecker;

/**
 * @param {vsctm.Registry} registry
 * @param {string} path
 * @param {string[]} fixture
 * @param {object} spec
 */
module.exports = async function(registry, path, fixture, spec) {
    const checker = new SpecChecker(spec);
    return getTokens(registry, path, fixture, (line, token) =>
        checker.checkToken(line, token)
    );
};
