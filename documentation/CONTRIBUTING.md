## How do I setup the project?

Take a look at `documentation/setup.md` for details on installing dependencies and such.

## Adding a Feature

If you believe you've successfully made a change.
- Create a `your_feature.YOUR_LANG_EXTENSION_HERE` file in the `language_examples/` folder. Once it is created, add code to it that demonstrates your feature (more demonstration the better).
- Then use `project test` to generate specs for all the examples.
- If there were no side effects, then `your_feature.spec.yaml` should be the only new/changed file. However, if there were side effects then some of the other `.spec.yaml` files will be changed. Sometimes those side effects are good, sometimes they're irrelevent, and often times they're a regression. 
- Once that is ready, make a pull request!

# How things work

- Everything really begins in `main/main.rb`
- The TLDR is
    - we create a grammar object
    - we create patterns using `Pattern.new` and `PatternRange.new`
    - we decide which patterns "go first" by putting them in the `grammar[:$initial_context]`
    - then we compile the grammar to a .tmLanguage.json file 

## If you already know about Textmate Grammars 

(So if you're like one of the 200 people on earth that have used textmate grammars)
<br>
Something like this in a tmLanguage.json file

```json
{
    "match": "blah/blah/blah",
    "name": "punctuation.separator.attribute.YOUR_LANG_EXTENSION_HERE",
    "patterns": [
        {
          "include": "#evaluation_context"
        },
        {
          "include": "#c_conditional_context"
        }
    ]
}
```

Becomes this inside main.rb

```ruby
Pattern.new(
    match: /blah\/blah\/blah/,
    tag_as: "punctuation.separator.attribute",
    includes: [
        :evaluation_context,
        :c_conditional_context,
    ],
)
```

And things like this

```json
{
    "begin": "\\[\\[",
    "end": "\\]\\]",
    "beginCaptures": {
        "0": {
            "name": "punctuation.section.attribute.begin.YOUR_LANG_EXTENSION_HERE"
        }
    },
    "endCaptures": {
        "0": {
            "name": "punctuation.section.attribute.end.YOUR_LANG_EXTENSION_HERE"
        }
    },
    "name": "support.other.attribute.YOUR_LANG_EXTENSION_HERE",
    "patterns": [
        {
            "include": "#attributes_context"
        },
    ]
}
```

Become this

```ruby
PatternRange.new(
    start_pattern: Pattern.new(
            match: /\[\[/,
            tag_as: "punctuation.section.attribute.begin"
        ),
    end_pattern: Pattern.new(
            match: /\]\]/,
            tag_as: "punctuation.section.attribute.end",
        ),
    tag_as: "support.other.attribute",
    # tag_content_as: "support.other.attribute", # <- alternative that doesnt double-tag the start/end
    includes: [
        :attributes_context,
    ]
)
```

To add something to the repository just do 

```ruby
grammar[:the_pattern_name] = Pattern.new(/blahblahblah/)
```

Where this gets really powerful is that you can nest/reuse patterns.

```ruby
smalltalk = Pattern.new(
    match: /blah\/blah\/blah/,
    tag_as: "punctuation.separator.attribute",
    includes: [
        :evaluation_context,
        :c_conditional_context,
    ],
)
quote = Pattern.new(
    match: /"/,
    tag_as: "quote",
)

phrase = Pattern.new(
    match: Pattern.new(/the man said: /).then(quote).then(smalltalk).then(quote),
    tag_as: "other.phrase",
)
```

## Readable Regex Guide

Regex is pretty hard to read, so this repo uses a library to help.
- `Pattern.new(*attributes)` or `.then(*attributes)` creates a new "shy" group
  - example: `Pattern.new(/foo/)` => `/(?:foo)/
- `.or(*attributes)` adds an alternation (`|`)
  - example: `Pattern.new(/foo/).or(/bar/)` => `/foo|(?:bar)/`
  - please note you may need more shy groups depending on order
    `Pattern.new(/foo/).or(/bar/).maybe(@spaces)` becomes (simplified) `/(?:foo|bar)\s*/`
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
  - example `Pattern.new(match: /foo|bar/, reference: "foobar").backreference("foobar")` => `/(foo|bar)\1/`

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

```ruby
# All available arguments (can't all be used at same time)
PatternRange.new(
    # typical aguments
    tag_as:  "",
    start_pattern: Pattern.new(),
    end_pattern:  Pattern.new(),
    includes: [],
    
    # unit testing arguments
    should_partial_match: [],
    should_not_partial_match: [],
    should_fully_match: [],
    should_not_fully_match: [],
    
    # advanced options
    tag_contents_as: "",
    while_pattern: Pattern.new(), # replaces "end_pattern" but the underlying behavior is strange, see: https://github.com/jeff-hykin/fornix/blob/877b89c5d4b2e51c6bf6bd019d3b34b04aaabe72/documentation/library/textmate_while.md#L1
    apply_end_pattern_last: false, # boolean, see https://www.apeth.com/nonblog/stories/textmatebundle.html
)
```

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
