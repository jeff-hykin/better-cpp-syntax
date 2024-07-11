<p align="center">
    <img height="90" alt="Screen Shot 2022-02-11 at 12 01 19 PM" src="https://user-images.githubusercontent.com/17692058/153645502-f106a481-faaf-450f-9f5e-10da3981d8dc.png">
</p>
<p align="center">
    <a href="https://marketplace.visualstudio.com/items?itemName=jeff-hykin.better-cpp-syntax">
        <img src="https://vsmarketplacebadge.apphb.com/downloads-short/jeff-hykin.better-cpp-syntax.svg?style=for-the-badge&colorA=5DDB61&colorB=4BC74F&label=DOWNLOADS" />
    </a>
    <a href="https://marketplace.visualstudio.com/items?itemName=jeff-hykin.better-cpp-syntax">
        <img src="https://vsmarketplacebadge.apphb.com/rating-star/jeff-hykin.better-cpp-syntax.svg?style=for-the-badge&colorA=FBBD30&colorB=F2AA08" />
    </a>
</p>

# Sponsors

<table>
    <thead>
        <tr>
            <th>
                <a href="https://bit.ly/3BdYRfu">
                    <img src=https://storage.googleapis.com/gitduck/img/duckly-sponsor-vsc-opt.png >
                </a>
            </th>
            <th>
                <p align="left">
                    Easy pair programming with any IDE. Duckly enables you to talk, share your code in real-time, server and terminal with people using different IDEs.
                    <br>
                    <a href="https://bit.ly/3BdYRfu">Try it out for free</a>
                </p>
            </th>
        </tr>
    </thead>
</table>

<!-- <img src=https://user-images.githubusercontent.com/17692058/153651656-2607a088-4b85-4729-9118-fe721246eb27.svg > -->

<br>

# What does this extension do?
This will get you the bleeding-edge syntax highlighting for C++. Which means your theme will be able to color your code better. This used to be a fix, but then VS Code starting using it as the official source for C and C++ highlighting.

NOTE: The default VS Code theme does not color much. Switch to the Dark+ theme (installed by default) or use a theme like one of the following to benefit from the changes:
- [XD Theme](https://marketplace.visualstudio.com/items?itemName=jeff-hykin.xd-theme)
- [Noctis](https://marketplace.visualstudio.com/items?itemName=liviuschera.noctis)
- [Kary Pro Colors](https://marketplace.visualstudio.com/items?itemName=karyfoundation.theme-karyfoundation-themes)
- [Material Theme](https://marketplace.visualstudio.com/items?itemName=Equinusocio.vsc-material-theme)
- [One Monokai Theme](https://marketplace.visualstudio.com/items?itemName=azemoh.one-monokai)
- [Winteriscoming](https://marketplace.visualstudio.com/items?itemName=johnpapa.winteriscoming)
- [Popping and Locking](https://marketplace.visualstudio.com/items?itemName=hedinne.popping-and-locking-vscode)
- [Syntax Highlight Theme](https://marketplace.visualstudio.com/items?itemName=peaceshi.syntax-highlight)
- [Default Theme Enhanced](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools-themes)

## How do I use the extension?
Just install the VS Code extension and the changes will automatically be applied to all relevant files.
<br>Link: https://marketplace.visualstudio.com/items?itemName=jeff-hykin.better-cpp-syntax

# Comparison (Material Theme)
<img width="2794" alt="compare" src="https://user-images.githubusercontent.com/17692058/153653793-3685ffd5-cf96-43c3-a883-da79ba33d037.png">

## How do I use the grammar? (as an upstream for my non-vs code editor)

1. Watch the the "Major Changes" thread [here](https://github.com/jeff-hykin/better-cpp-syntax/issues/64) to know when I change licenses, the codebase structure, or just major highlighting changes.
2. I support non-VS Code usecases. E.g. yes, you are welcome to open issues [like this one](https://github.com/jeff-hykin/better-cpp-syntax/issues/653) that don't affect VS Code.

## What is different from atom/language-c?
It fixes:
- The issue of single quotes inside #error and #warning being highlighted when then shouldn't be 
- The issue of initialization functions only highlighting the first parenthesis
- The bug that treats the 'and' and 'or' operator as functions (instead of operators) when they are followed by ()'s
- Old C99 function highlighting that broke the standard function highlighting
- The failure of highlighting for the semicolon after namespaces
- The missing operator overloading symbols
- The failure to tag operator overloading functions as functions
- The failure to tag implicit operator overrides
- The marking of some %'s as invalid inside of strings https://github.com/atom/language-c/issues/289
- The highlighting of namespaces with ::'s https://github.com/atom/language-c/issues/260 
- The issue of the C++ syntax depending on (and getting screwed up by) the C syntax
- multiple inheritance https://github.com/atom/language-c/issues/245
- And many many more issues (#318, #309, #270, #246, etc)

It adds:
- Parameter highlighting
- Highlighting of embedded assembly code (if you have an assembly syntax installed)
- Function-pointer highlighting
- Lambda highlighting
- C++14 literal support (`100'000ms`)
- Template definition syntax highlighting (including C++ 2020 syntax)
- Better object identification
- Improved scope resolution `::` syntax
- Highlighting of templated function calls `aFunction<int>(arguments)`
- Additional specificity for many existing tags
- Many other features

### Like this extension?
<ul>
    <li>
        You'll probably like this as well: <a href="https://marketplace.visualstudio.com/items?itemName=jeff-hykin.better-syntax">My "Better Syntax" Megapack</a>
    </li>
</ul>

## Contributing
If you'd like to help improve the syntax, take a look at `main/main.rb`. And make sure to take a look at `documentation/CONTRIBUTING.md` to get a better idea of how the code works.

Planned future fixes/features:
- Add tagging for type-casting statements
- Add tagging for custom types words
- Better support for dereferenced/pointer tagging
- Full C++ 2020 support (module imports, arrow return types, etc.)
- Improving template types

## What if I see a highlighting bug?
Let me know! Post an issue on https://github.com/jeff-hykin/better-cpp-syntax
I love regular expressions, and PR's are always welcome.

## Did you write all of this yourself?
The original JSON was taken from https://github.com/atom/language-c
<br>@matter123 wrote every massive pull request, from simple bugfixes up to the entire textmate testing suite
<br>@j-cortial has fixed many lingering bugs
<br>The #error fix was taken from fnadeau's pull request here: https://github.com/atom/language-c/pull/251
<br>Thank you @matter123, @j-cortial, and @fnadeau!
<br>The rest of the ruby is authored by @jeff-hykin
