# cpp-textmate-grammer
An update to the syntax highlighting of c++ code

## What does this do?
It improves the highlighting of C++ and C code. (See screenshots below)

## What does this do different?
It fixes:
- The issue of single quotes inside #error and #warning being highlighted when then shouldn't be 
- The issue that initilization functions only highlighted the first paraenthese 
- The bug that treats the 'and' and 'or' operator as functions (instead of operators) when they are followed by ()'s
- Old C99 function highlighting that broke the standard function highlighting
- The failure of highlighting for the semicolon after namespaces
- The missing operator overloading symbols
- The failure to tag operator overloading functions as functions

It adds:
- Additional specificity for many existing tags
- Template definition syntax highlighting
- Parameter highlighting
- better object identification

### Normal C++
![without-syntax-improvement](https://user-images.githubusercontent.com/17692058/52240797-8d75ef80-2897-11e9-97b6-f94af43d9fb7.png)
### Better C++
![with-syntax-improvement](https://user-images.githubusercontent.com/17692058/52240803-8fd84980-2897-11e9-987c-9c71c19d52fa.png)

## What if I see a highlighting bug
Let me know! Post an issue on https://github.com/jeff-hykin/cpp-textmate-grammer

## Are their any planned improvements?
Pull requests are welcome! Theres no way one person can test every syntax combination.

Future additions:
- Improve the scope :: operator tags
- Tagging for type-casting statements
- Tagging for template-usage (rather than only template definition)
- Tagging for custom types
- Better support for function pointer tagging
- Better support for dereferenced/pointer tagging
