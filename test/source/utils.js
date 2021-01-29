let pathFor = require("./paths")
let path = require("path")

module.exports = {
    removeScopeName: (scope) => {
        let languageEndings = pathFor.eachLanguage.map(each => path.basename(each))
        let matchEnding = RegExp(`\\\.(?:${languageEndings.join("|")})$`,"g")
        return scope.replace(matchEnding, "");
    },
}

