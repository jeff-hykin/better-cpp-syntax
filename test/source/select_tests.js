const fs = require("fs");
const { execSync } = require("child_process");
const path = require("path");

const pathFor = require("./paths");

const defaultTest = test =>
    fs.existsSync(test.spec.yaml) || !fs.existsSync(test.spec.json);

module.exports = function(yargs) {
    if (yargs.fixtures.length !== 0 || yargs.all) {
        return defaultTest;
    }
    const status = execSync("git status --porcelain").toString();
    if (status.trim() == "") {
        // git is clean do all tests
        return defaultTest;
    }
    let fileExt = [];
    for (const line of status.split("\n")) {
        const match = / M (syntaxes\/.+\.tmLanguage.json)/.exec(line);
        if (match) {
            fileExt = fileExt.concat(
                JSON.parse(
                    fs
                        .readFileSync(path.join(pathFor.root, match[1]))
                        .toString()
                )["fileTypes"]
            );
        }
    }
    if (fileExt.length === 0) {
        return defaultTest;
    }
    return test => {
        const ext = path.extname(test.fixture).slice(1);
        return defaultTest(test) && fileExt.includes(ext);
    };
};
