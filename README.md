# cpp-textmate-grammer
An update to the syntax highlighting of c++ code


This fixes:
- The issue of single quotes inside #error and #warning not being defined
- The bug that treats the 'and' and 'or' operator as functions when they are followed by ()'s
- The failure of highlighting for the semicolon after namespaces
- The failure to match operator overloading functions as functions

This adds:
- Additional specificity for many existing tags
- Template definition syntax highlighting
- Parameter highlighting
