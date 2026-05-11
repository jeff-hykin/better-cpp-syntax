## How do I setup the project?

Take a look at `documentation/setup.md` for details on installing dependencies and such.

## Adding a Feature

If you believe you've successfully made a change.
- Create a `your_feature.cpp` file in the `language_examples/` folder. Once it is created, add C++ code to it that demonstrates your feature (more demonstration the better).
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
- Sadly the C++ repo is a bit of spaghetti, due in large part to the language complexity

## If you already know about Textmate Grammars 

(So if you happen to be one of the approximately 200 people on earth that have used textmate grammars)
Something like this in a tmLanguage.json file

```json
{
    "match": "blah/blah/blah",
    "name": "punctuation.separator.attribute.cpp",
    "patterns": [
        {
          "include": "#evaluation_context"
        },
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
            "name": "punctuation.section.attribute.begin.cpp"
        }
    },
    "endCaptures": {
        "0": {
            "name": "punctuation.section.attribute.end.cpp"
        }
    },
    "name": "support.other.attribute.cpp",
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

To add something to the grammar's repository just do 

```ruby
grammar[:the_pattern_name] = Pattern.new(/blahblahblah/)
```

Where this gets really powerful is that you can nest/reuse patterns.

```ruby
quote = Pattern.new(
    match: /"/,
    tag_as: "punctuation",
)

smalltalk = Pattern.new(
    match: /blah\/blah\/blah/,
    tag_as: "punctuation.separator.attribute",
    includes: [
        :evaluation_context,
    ],
)

phrase = Pattern.new(
    match: Pattern.new(/the man said: /).then(quote).then(smalltalk).then(quote),
    tag_as: "other.phrase",
)
```

## Readable Regex Guide

Regex is pretty hard to read, so this repo uses a library to help.

### Pattern API Overview

- `Pattern.new(*attributes)` or `.then(*attributes)` creates a new "shy" group
  - example: `Pattern.new(/foo/)` => `/(?:foo)/
- `.or(*attributes)` adds an alternation (`|`)
  - example: `Pattern.new(/foo/).or(/bar/)` => `/foo|(?:bar)/`
  - please note you may need more shy groups depending on order
    `Pattern.new(/foo/).or(/bar/).maybe(@spaces)` becomes (simplified) `/(?:foo|bar)\s*/` NOT `/(?:foo|bar\s*)/` 
- `maybe(*attributes)` or `.maybe(*attributes)` causes the pattern to match zero or one times (`?`)
  - example `maybe(/foo/)` => `/(?:foo)?/`
- `zeroOrMoreOf(*attributes)` or `.zeroOrMoreOf(*attributes)` causes the pattern to be matched zero or more times (`*`)
  - example `zeroOrMoreOf(/foo/)` => `/(?:foo)*/`
- `oneOrMoreOf(*attributes)` or `.oneOrMoreOf(*attributes)` causes the pattern to be matched one or more times (`+`)
  - example `oneOrMoreOf(/foo/)` => `/(?:foo)+/`
- `lookBehindFor(regex)` or `.lookBehindFor(regex)` add a positive lookbehind
  - example `lookBehindFor(/foo/)` => `/(?<=foo)/`
- `lookBehindToAvoid(regex)` or `.lookBehindToAvoid(regex)` add a negative lookbehind
  - example `lookBehindToAvoid(/foo/)` => `/(?<!foo)/`
- `lookAheadFor(regex)` or `.lookAheadFor(regex)` add a positive lookahead
  - example `lookAheadFor(/foo/)` => `/(?=foo)/`
- `lookAheadToAvoid(regex)` or `.lookAheadToAvoid(regex)` add a negative lookahead
  - example `lookAheadToAvoid(/foo/)` => `/(?!foo)/`
- `recursivelyMatch(reference)` or `.recursivelyMatch(reference)` adds a regex subexpression
  - for example here's a pattern that would match `()`, `(())`, `((()))`, etc
  - `Pattern.new(match: Pattern.new( "(" ).recursivelyMatch("foobar").or("").then( ")" ), reference: "foobar")`
  - as normal ruby-regex it would look like: `/(\(\g<1>\))/`
- `matchResultOf(reference)` or `.matchResultOf(reference)` adds a backreference
  - example `Pattern.new(match: /foo|bar/, reference: "foobar").matchResultOf("foobar")` => `/(foo|bar)\1/`
  - matches: `foofoo` and `barbar` but not `foobar`


### Pattern API Details

- The `*attributes` can be:
    - A regular expression: `Pattern.new(/stuff/)`
    - Another pattern: `Pattern.new(Pattern.new(/blah/))`)
    - Or a bunch of named arguments: `Pattern.new({ match: /stuff/, })`

Here's a comprehesive list of named arguments (not all can be used together)

```ruby
Pattern.new(
    # unit tests
    should_partial_match: [ "example text", ],
    should_fully_match:   [ "example text", ],
    should_not_partial_match: [ "example text", ],
    should_not_fully_match:   [ "example text", ],
    
    # typical arguments
    match: //,     # regex or another pattern
    tag_as: "",    # string (textmate scope, which can contain space-sperated scopes)
    comment: "",   # a comment that will show up in the final generated-grammar file (rarely used)
    includes: [
        :other_pattern_name,
        # alternatively include Pattern.new OR PatternRange.new directly
        PatternRange.new(
            # stuff 
        ),
    ],
    # NOTE! if "includes:" is used then Textmate will ignore any sub-"tag_as"
    #       if "match:" is regex then this is not a problem (there are no sub-"tag_as"'s)
    #       BUT something like match: Pattern.new(match:/sub-thing1/,).then(match:/sub-thing2/, tag_as: "blah")
    #       then the tag_as: "blah" will get 
    #       and instead let the included patterns do all the tagging
    
    
    # 
    # repetition arguments
    # 
    at_least: 3.times,
    at_most: 5.times,
    how_many_times?: 5.times, # repeat exactly 5 times
    
    # the follow two only works in repeating patterns (like at_least: ... or zeroOrMoreOf(), or oneOrMoreOf())
    as_few_as_possible?: false,
    # equivlent to regex lazy option
    # default value is false
    # see https://stackoverflow.com/questions/2301285/what-do-lazy-and-greedy-mean-in-the-context-of-regular-expressions
    # "as_few_as_possible?:" has an equivlent alias "lazy?:"
    dont_back_track?: false,
    # this is equivlent to regex atomic groups (can be efficient)
    # default value is false
    # http://www.rexegg.com/regex-disambiguation.html#atomic
    # "dont_back_track?:" has an equivlent alias "possessive?:"
    
    # 
    # advanced
    # 
    word_cannot_be_any_of: [ "word1" ], # default=[]
    # this is highly useful for matching var-names while not matching builtin-keywords
    # HOWEVERY only use this if
    # 1. you're matching the whole word, not a small part of a word
    # 2. the pattern always matches something (the pattern cant match an empty string)
    # 3. what you consider a "word" matches the regex boundary's (\b) definition, meaning;
    #    underscore is not a seperator, dash is a seperator, etc
    # this has limited usecase but is very useful when needed
    
    reference: "", # to create a name that can be referenced later for (regex backreferences)
    preserve_references?: false, # default=false, setting to true will allow for 
    # reference name conflict. Usually the names are scrambled to prevent name-conflict
    
    # 
    # internal API (dont use directly, but listed here for comprehesiveness sake)
    # 
    backreference_key: "reference_name", # use matchResultOf(), which is equivlent to regex backreference
    subroutine_key: "reference_name",    # use recursivelyMatch(), which is equivlent to regex subroutine
    type: :lookAheadFor, # only valid values are :lookAheadFor, :lookAheadToAvoid, :lookBehindFor, :lookBehindToAvoid
                         # just used as a means of implementing lookAheadFor(), lookAheadToAvoid(), etc
    placeholder: "name", # useful for recursive includes or patterns; grammar[:a_pattern] will return a placeholder
                         # if the pattern has not been created yet (e.g. grammar[:a_pattern] = a_pattern)
                         # when a grammar is exported unresolved placeholders will throw an error
    adjectives: [ :isAKeyword, ],   # a list of adjectives that describe the pattern, part of an untested grammar.tokenMatching() feature
    pattern_filter: ->(pattern) {}, # part of untested grammar.tokenMatching() feature, only works with placeholders
)
```

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
    
    # 
    # advanced options
    # 
    tag_contents_as: "", # NOTE; this is an alternative to "tag_as:" not to be used in combination
    while_pattern: Pattern.new(),
    # replaces "end_pattern" but the underlying behavior is strange, see: https://github.com/jeff-hykin/fornix/blob/74272281599174dcfc4ef163b770b2d5a1c5dc05/documentation/library/textmate_while.md#L1
    apply_end_pattern_last: false,
    # default=false, rarely used but can be important
    # see https://www.apeth.com/nonblog/stories/textmatebundle.html
    # also has an alias "end_pattern_last:"
    # also (for legacy reasons) has an alias "applyEndPatternLast:"
    
    tag_start_as: "", # not really used, instead just do start_pattern: Pattern.new(match:/blah/, tag_as:"blah")
    tag_end_as:   "", # not really used, instead just do end_pattern: Pattern.new(match:/blah/, tag_as:"blah")
    tag_while_as: "", # not really used, instead just do while_pattern: Pattern.new(match:/blah/, tag_as:"blah")
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
