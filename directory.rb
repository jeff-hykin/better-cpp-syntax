require 'json'
require 'yaml'
require 'fileutils'
require 'pathname'

PathFor = {
    root:           __dir__,
    package_json:    File.join(__dir__, "package.json"                                                                    ),
    temp_readme:     File.join(__dir__, "temp_readme.md"                                                                  ),
    generic_readme:  File.join(__dir__, "generic_readme.md"                                                               ),
    readme:          File.join(__dir__, "README.md"                                                                       ),
    repo_helper:     File.join(__dir__, "source"             , "repo_specific_helpers.rb"                                 ),
    textmate_tools:  File.join(__dir__, "source"             , "textmate_tools.rb"                                        ),
    svg_helper:      File.join(__dir__, "scripts"            , "helpers"              , "convert_svgs.js"                 ),
    languages:       File.join(__dir__, "source"             , "languages"                                                ),
    fixtures:        File.join(__dir__, "test"               , "fixtures"                                                 ),
    report:          File.join(__dir__, "test"               , "source"               , "commands"          , "report.js" ),
    syntaxes:        File.join(__dir__, "syntaxes"                                                                        ),
    linter:          File.join(__dir__, "lint"               , "index.js"                                                 ),
    
    relativeIconPng:  ->(lang_extension) { File.join("icons", lang_extension+".png"                                                             ) },
    sharedPattern:    ->(pattern_name  ) { File.join(__dir__, "source"                  , "shared_patterns"                , pattern_name+".rb" ) },
    svgIcon:          ->(lang_extension) { File.join(__dir__, "icons"                   , lang_extension+".svg"                                 ) },
    pngIcon:          ->(lang_extension) { File.join(__dir__, "icons"                   , lang_extension+".png"                                 ) },
    languageTag:      ->(lang_extension) { File.join(__dir__, "language_tags"           , lang_extension+".txt"                                 ) },
    jsonSyntax:       ->(lang_extension) { File.join(PathFor[:syntaxes]                 , lang_extension+".tmLanguage.json"                     ) },
    yamlSyntax:       ->(lang_extension) { File.join(PathFor[:syntaxes]                 , lang_extension+".tmLanguage.yaml"                     ) },
    language:         ->(lang_extension) { File.join(PathFor[:languages]                , lang_extension                                        ) },
    localReadMe:      ->(lang_extension) { File.join(PathFor[:language][lang_extension], "README.md"                                            ) },
    localPackageJson: ->(lang_extension) { File.join(PathFor[:language][lang_extension], "package.json"                                         ) },
    generator:        ->(lang_extension) { File.join(PathFor[:language][lang_extension], "generate.rb"                                          ) },
    macro_generator:  ->(lang_extension) { File.join(PathFor[:language][lang_extension], "generate_macro_bailout.js"                            ) },
}