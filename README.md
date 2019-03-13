# What does this do?
This will get you the bleeding-edge syntax highlighting for C++.
This used to be a fix, but then VS Code starting using it as the official source for C++ highlighting.

## How do I use it?
Just install the VS Code extension and the changes will automatically be applied to all C++/C files.

### Before Better C++
![without-syntax-improvement](https://user-images.githubusercontent.com/17692058/52240797-8d75ef80-2897-11e9-97b6-f94af43d9fb7.png)
### After
![with-syntax-improvement](https://user-images.githubusercontent.com/17692058/52240803-8fd84980-2897-11e9-987c-9c71c19d52fa.png)

## What is different from atom/language-c?
It fixes:
- The issue of single quotes inside #error and #warning being highlighted when then shouldn't be 
- The issue of initilization functions only highlighting the first paraenthese
- The bug that treats the 'and' and 'or' operator as functions (instead of operators) when they are followed by ()'s
- Old C99 function highlighting that broke the standard function highlighting
- The failure of highlighting for the semicolon after namespaces
- The missing operator overloading symbols
- The failure to tag operator overloading functions as functions
- The failure to tag implicit operator overrides
- The marking of some %'s as invalid inside of strings https://github.com/atom/language-c/issues/289
- The highlighting of namespaces with ::'s https://github.com/atom/language-c/issues/260 
- The issue of the C++ syntax depending on (and getting screwed up by) the C syntax
- And many many more issues (#318, #309, #270, #246, etc)

It adds:
- Parameter highlighting
- C++14 literal support (`100'000ms`)
- Better object identification
- Improved scope resultion `::` syntax
- Highlighting of templated function calls `aFunction<int>(arguments)`
- Template definition syntax highlighting (including C++ 2020 syntax)
- Additional specificity for many existing tags
- Tags for the colon in ranged-based for loops
- Many other features

## Contributing
This is a project that is converting legacy JSON file into ruby files generate a JSON file. The main ruby file "generate.rb" uses tools (that are in beta) that help generate the JSON file. If you want to contribute, take a look at `number_literal = newPattern(` inside of "generate.rb" to see how the new syntax looks. Take a look at `"comments-c" => {` to see how the old syntax looks. The code is ready for contributions, and in the future there will be much more documentation for contributors.

Planned future fixes/featues:
- Fix multiple inheritance https://github.com/atom/language-c/issues/245
- Start coding patterns according to the offical C++ syntax specifications
- Fix function-pointer tagging
- Add tagging for type-casting statements
- Add tagging for template-usage (rather than only template definition)
- Add tagging for custom types words
- Better support for dereferenced/pointer tagging
- Add support for lambda highlighting (this is going to be tough)

## What if I see a highlighting bug?
Let me know! Post an issue on https://github.com/jeff-hykin/cpp-textmate-grammar
I love regular expressions, and I plan on actively maintaining this.

## Did you write all of this youself?
The original JSON was taken from https://github.com/atom/language-c
<br>The #error fix was taken from fnadeau's pull request here: https://github.com/atom/language-c/pull/251
<br>There was a pull request on this repo from matter123 that fixed number literals.
<br>Thanks fnadeau, and matter123!
<br>The rest of the ruby code is authored by me.