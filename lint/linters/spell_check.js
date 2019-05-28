var path = require("path");
var baseDict = require.resolve("dictionary-en-us");
const fs = require("fs");
const nspell = require("nspell");
const _ = require("lodash");
const util = require("util");
const chalk = require("chalk");

/**
 * @type {nspell.NSpell}
 */
let spell = nspell(
    fs.readFileSync(path.join(baseDict, "..", "index.aff"), "utf-8"),
    fs.readFileSync(path.join(baseDict, "..", "index.dic"), "utf-8")
);
[
    "accessor",
    "alignas",
    "alignof",
    "bitwise",
    "c",
    "cpp",
    "decltype",
    "dereference",
    "destructor",
    "elif",
    "enum",
    "enummember",
    "extern",
    "gt",
    "initializer",
    "lt",
    "namespace",
    "overloadee",
    "parens",
    "posix",
    "pragma",
    "preprocessor",
    "pthread",
    "qualified_type",
    "readwrite",
    "sizeof",
    "static_assert",
    "stdint",
    "struct",
    "sys",
    "toc",
    "typedef",
    "typeid",
    "typename",
    "undef",
    "vararg",
    "whitespace"
].forEach(word => spell.add(word));

class Spellcheck {
    constructor() {
        this.messages = [];
        this.doSpellcheck = this.doSpellcheck.bind(this);
    }
    doSpellcheck(name) {
        if (name.includes(" ")) {
            return _.some(name.split(" ").map(this.doSpellcheck));
        }
        if (name.includes(".")) {
            return _.some(name.split(".").map(this.doSpellcheck));
        }
        if (name.includes("-")) {
            return _.some(name.split("-").map(this.doSpellcheck));
        }
        // remove like at ebd of words "wordlike" => "word"
        name = name.replace(/like$/, "");
        if (/^\$\d+$/.test(name)) return false;
        if (!spell) return false;
        //console.log(name, spell.correct(name));
        return !spell.correct(name);
    }
    reportError(rule, word) {
        let message = word + " is not spelled correctly. ";
        if (rule.repositoryName) {
            message += "Rule is " + rule.repositoryName;
        } else {
            message += "Rule is " + util.inspect(rule, false, 1, false);
        }
        this.messages.push(message);
    }
    firstPass(rule) {
        if (rule.name) {
            if (this.doSpellcheck(rule.name)) {
                this.reportError(rule, rule.name);
            }
        }
        if (rule.contentName) {
            if (this.doSpellcheck(rule.contentName)) {
                this.reportError(rule, rule.contentName);
            }
        }
    }

    finalReport() {
        for (const message of this.messages) {
            console.warn(chalk.yellowBright("[Spellcheck]  ", message));
        }
        return this.messages.length == 0;
    }
}

module.exports = new Spellcheck();
