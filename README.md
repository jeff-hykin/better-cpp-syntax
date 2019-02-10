# What does this do?
It improves the highlighting of C++ and C code (See screenshots). 

## How do I use it?
Just install the VS Code extension and the changes will automatically be applied to all C++/C files.

### Normal C++
![without-syntax-improvement](https://user-images.githubusercontent.com/17692058/52240797-8d75ef80-2897-11e9-97b6-f94af43d9fb7.png)
### Better C++
![with-syntax-improvement](https://user-images.githubusercontent.com/17692058/52240803-8fd84980-2897-11e9-987c-9c71c19d52fa.png)

## What does this do different?
It fixes:
- The issue of single quotes inside #error and #warning being highlighted when then shouldn't be 
- The issue of initilization functions only highlighting the first paraenthese
- The bug that treats the 'and' and 'or' operator as functions (instead of operators) when they are followed by ()'s
- Old C99 function highlighting that broke the standard function highlighting
- The failure of highlighting for the semicolon after namespaces
- The missing operator overloading symbols
- The failure to tag operator overloading functions as functions
- The failure to tag implicit operator overrides
- The issue of the C++ syntax depending on (and getting screwed up by) the C syntax

It adds:
- Additional specificity for many existing tags
- Template definition syntax highlighting (including C++ 2020 syntaxes)
- Parameter highlighting
- better object identification
- Tags for the colon in ranged-based for loops

Planned future fixes/featues:
- Fix more of the syntax-breaking bugs from https://github.com/atom/language-c/issues
- Fix more of the easy-to-fix bugs from https://github.com/atom/language-c/issues
  - Fix the ## issue (https://github.com/atom/language-c/issues/318)
  - Improve the scope resultion `::` syntax-tags
- Add tagging for type-casting statements
- Add tagging for template-usage (rather than only template definition)
- Add tagging for probably-a-custom-type words
- Better support for function pointer tagging
- Better support for dereferenced/pointer tagging
- Add support for lambda highlighting (this is going to be tough)

## What if I see a highlighting bug?
Let me know! Post an issue on https://github.com/jeff-hykin/cpp-textmate-grammar
I love regular expressions, and I plan on actively maintaining this.

## So whats the deal with the built-in C++ stynax?
The standard C++ sytax (for both Atom and VS Code) looks like a bunch of hacked-together solutions with no standards. The regex and pattern matching is so complicated to read that I think nobody wants to change it. There's missing keywords, misspelled keywords, theres copy-and-pasted patterns everywhere, there's duplicated logic, there's groups that were matched but forgot to ever be tagged.

I hope I will have the time to standardize it by having the .json files be generated completely by the ruby file. It will make the regex readable and prevent code duplication (which will make the code actually maintainable).

## Did you write all of this youself?
No, absolutely not. This is only a modifcation of https://github.com/atom/language-c;

## Did you write all the improvements yourself?
Nope, the #error fix was taken from fnadeau's pull request here: https://github.com/atom/language-c/pull/251
Thanks fnadeau! that was a well written soltuion.
