const path = require("path");

const testDir = path.dirname(__dirname);
const fixtureDir = path.join(testDir, "fixtures");
const specDir = path.join(testDir, "specs");
module.exports.testDir = testDir;
module.exports.fixtureDir = fixtureDir;
module.exports.specDir = specDir;
