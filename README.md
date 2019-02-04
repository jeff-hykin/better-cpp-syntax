# cpp-textmate-grammer
An update to the syntax highlighting of c++ code

This fixes:
- The issue of single quotes inside #error and #warning being highlighted when then shouldn't be 
- The bug that treats the 'and' and 'or' operator as functions (instead of operators) when they are followed by ()'s
- Old C99 function highlighting that broke the standard function highlighting
- The failure of highlighting for the semicolon after namespaces
- The missing operator overloading symbols
- The failure to tag operator overloading functions as functions

This adds:
- Additional specificity for many existing tags
- Template definition syntax highlighting
- Parameter highlighting
- better object identification

Future additions:
- Tagging for custom types 
- Tagging for type-casting statements
- Better support for function pointer syntax
- Better support for dereferenced/pointer types