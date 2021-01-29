const getTokens = require("./get_tokens");
const SpecChecker = require("./spec_checker").SpecChecker;

/**
 * @param {vsctm.Registry} registry
 * @param {string} path
 * @param {string[]} fixture
 * @param {object} spec
 */
module.exports = async function(
    registry,
    path,
    fixture,
    spec,
    showFailureOnly
) {
    const checker = new SpecChecker(spec, showFailureOnly);
    return getTokens(
        registry,
        path,
        fixture,
        showFailureOnly,
        false,
        (line, token) => checker.checkToken(line, token)
    );
};
