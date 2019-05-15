## How do I setup the project?

1. Make sure you have ruby, node and npm installed.
2. Clone or fork the repo.
3. Run `npm install`
4. Run `npm test` to make sure everything is working
5. Then inside VS Code, start the debugger (F5 for windows / Mac OS / Linux)
6. Then open up a C++ file, and any changes made to the project will show up in the syntax of that file.
7. Every time you make a change, just press the refresh button on the debugger pop up.

## Mapping textmate grammar constructs to readable grammars
For a single pattern rule:
- captures are replaced with tagging sub expressions (see readable regex tutorial later)
- in scope name `$0` becomes `$match` and `$N` becomes `$reference(name)`
- `"captures": {"0": {"patterns": [...]}}` is just `includes:`

For begin/end rules:
- `contentName:` is renamed to `tag_content_as:`
- `begin:` is renamed to `start_pattern:`
- `end:` is renamed to `end_pattern:`
- `beginCaptures` and `endCaptures` are replaced with tagged sub-expressions on `start_pattern` and `end_pattern` respectively
- `patterns:` is renamed to `includes`

For both single pattern and begin/end rules:
- `name:` is renamed to `tag_as:`
- use ruby symbols `:repository_name:` instead of `"#repository_name` in `includes:`
- to add a rule to the repository use `cpp_grammar[:repository_name] = newPattern(...)`

## Readable Regex Guide
the following helpers exist to create a more readable regex syntax
- `newPattern(*attributes)` or `.then(*attributes)` create a new "shy" group
  - example: `newPattern(/foo/)` => `/(?:foo)/
- `.or(*attributes)` adds an alternation (`|`)
  - example: `/foo/.or(/bar/)` => `/foo|(?:bar)/`
  - please note you may need more shy groups depending on order
    `/foo/.or(/bar/).maybe(@spaces)` becomes (simplified) `/foo|bar\s*/` not `/(?:foo|bar)\s*/` for that you need
    
    `newPattern(/foo/.or(/bar/)).maybe(@spaces)`
- `maybe(*attributes)` or `.maybe(*attributes)` causes the pattern to match zero or one times (`?`)
  - example `maybe(/foo/)` => `/(?:foo)?/`
- `zeroOrMoreTimes(*attributes)` or `.zeroOrMoreTimes(*attributes)` causes the pattern to be matched zero or more times (`*`)
  - example `zeroOrMoreTimes(/foo/)` => `/(?:foo)*/
- `oneOrMoreTimes(*attributes)` or `.oneOrMoreTimes(*attributes)` causes the pattern to be matched one or more times (`+`)
  - example `oneOrMoreTimes(/foo/)` => `/(?:foo)+/
- `lookBehindFor(regex)` or `.lookBehindFor(regex)` add a positive lookbehind
  - example `lookBehindFor(/foo/)` => `/(?<=foo)/
- `lookBehindToAvoid(regex)` or `.lookBehindToAvoid(regex)` add a negative lookbehind
  - example `lookBehindToAvoid(/foo/)` => `/(?<!foo)/
- `lookAheadFor(regex)` or `.lookAheadFor(regex)` add a positive lookahead
  - example `lookAheadFor(/foo/)` => `/(?=foo)/
- `lookAheadToAvoid(regex)` or `.lookAheadToAvoid(regex)` add a negative lookahead
  - example `lookAheadToAvoid(/foo/)` => `/(?!foo)/
- `backreference(reference)` or `.backreference(reference)` adds a backreference
  - example `newPattern(match: /foo|bar/, reference: "foobar").backreference("foobar")` => `/(foo|bar)\1/`

helpers that are marked as accepting `*attributes` can accept either a regular expression, a hash that provide more info, or a variable that is either of those.

the hash provided to the helper patterns can have the following keys:
  - `match:` the regular expression that should be matched
  - `tag_as:` the scope-name to give this sub-expression
  - `reference:` a name used to refer to this sub-expression in a `tag_as` or `back_reference`
  - `comment:` unused, use regular ruby comments
  - `should_partial_match`, `should_not_partial_match`, `should_fully_match`, and `should_not_fully_match` see unit testing

look{Ahead,Behind}{ToAvoid,For} helpers only accept regular expressions use `.without_numbered_capture_groups` to convert a pattern to a regular expression

### PatternRange
`PatternRange.new` is used to create a begin/end pattern rule.

## Testing
### Unit Testing
By supplying one of the unit testing keys to the pattern, you can ensure that pattern only matches what you want it to.

- `should_partial_match` asserts that the pattern matches anywhere in the test strings
- `should_not_partial_match` asserts that the pattern does not match at all in the test strings.
- `should_fully_match` asserts that the pattern matches all the characters in the test strings.
- `should_not_fully_match` asserts that the pattern does not match all the characters in the test strings.
  - note: `should_not_fully_match` does not imply `should_partial_match`, that is a failure to match satisfies `should_not_fully_match` 

### Integration Testing
Integration testing uses `vscode-textmate` to confirm that that the fixture files (found at `test/fixtures`) have the same tokens and scopes as described in the spec files (found at `test/specs`). Each issue should have a fixture and spec file or an entry in `test/fixtures/issues/skipped issues` explaining why it was skipped.

#### Commands
`npm test [path/to/fixture]` runs the specified test or all if no test specified.
`npm run generate-specs [-- --generate-all] [-- path/to/fixture]` used to generate spec files for newly added fixtures, or, if needed, the specified fixture, or all of them.
`npm run sort-specs` used to resort the spec keys. This command has no effect on the passing/not passing status of a test

## Other Resources
- https://code.visualstudio.com/api/language-extensions/syntax-highlight-guide Visual Studio Code's guide to language grammar
- https://macromates.com/manual/en/language_grammars Textmate's guide to language grammars.
- https://www.sublimetext.com/docs/3/scope_naming.html Sublime Text's guide to textmate scope selection.
- https://www.apeth.com/nonblog/stories/textmatebundle.html More explanation on how grammars are structured.
- https://rubular.com/ Ruby compatible regular expression tester
- https://github.com/stedolan/jq/wiki/Docs-for-Oniguruma-Regular-Expressions-(RE.txt) Documentation for Oniguruma flavored (textmate) regular expressions
- https://github.com/Microsoft/vscode-textmate the Textmate grammar parser for Visual Studio Code
