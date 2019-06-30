# The application shall quote the following characters if they are to represent themselves:
# |  &  ;  <  >  (  )  $  `  \  "  '  <space>  <tab>  <newline>

# and the following may need to be quoted under certain circumstances. That is, these characters may be special depending on conditions described elsewhere in this volume of POSIX.1-2017:
# *   ?   [   #   ˜   =   %

# reserved words
# ! { } case do done elif else esac fi for if in then until while
# [[ ]] function select

# Shell Variables 
# ENV HOME IFS LANG LC_ALL LC_COLLATE LC_CTYPE LC_MESSAGES LINENO NLSPATH PATH PPID PS1 PS2 PS4 PWD

# utils
# alias bg cd command false fc fg getopts hash jobs kill newgrp pwd read true umask unalias wait

require_relative '../../textmate_tools.rb'

tokens = [
    { representation: '|' , areInvalidLiterals: true },
    { representation: '&' , areInvalidLiterals: true },
    { representation: ';' , areInvalidLiterals: true },
    { representation: '<' , areInvalidLiterals: true },
    { representation: '>' , areInvalidLiterals: true },
    { representation: '(' , areInvalidLiterals: true },
    { representation: ')' , areInvalidLiterals: true },
    { representation: '$' , areInvalidLiterals: true },
    { representation: '`' , areInvalidLiterals: true },
    { representation: '\\', areInvalidLiterals: true },
    { representation: '"' , areInvalidLiterals: true },
    { representation: '\'', areInvalidLiterals: true },
    { representation: "function" , areNonCommands: true, },
    { representation: "select"   , areNonCommands: true, },
    { representation: "case"     , areNonCommands: true, },
    { representation: "do"       , areNonCommands: true, },
    { representation: "done"     , areNonCommands: true, },
    { representation: "elif"     , areNonCommands: true, },
    { representation: "else"     , areNonCommands: true, },
    { representation: "esac"     , areNonCommands: true, },
    { representation: "fi"       , areNonCommands: true, },
    { representation: "for"      , areNonCommands: true, },
    { representation: "if"       , areNonCommands: true, },
    { representation: "in"       , areNonCommands: true, },
    { representation: "then"     , areNonCommands: true, },
    { representation: "until"    , areNonCommands: true, },
    { representation: "while"    , areNonCommands: true, },
    { representation: "alias"    , areNonCommands: true, },
    { representation: "bg"       , areNonCommands: true, },
    { representation: "command"  , areNonCommands: true, },
    { representation: "false"    , areNonCommands: true, },
    { representation: "fc"       , areNonCommands: true, },
    { representation: "fg"       , areNonCommands: true, },
    { representation: "getopts"  , areNonCommands: true, },
    { representation: "hash"     , areNonCommands: true, },
    { representation: "jobs"     , areNonCommands: true, },
    { representation: "kill"     , areNonCommands: true, },
    { representation: "newgrp"   , areNonCommands: true, },
    { representation: "read"     , areNonCommands: true, },
    { representation: "true"     , areNonCommands: true, },
    { representation: "umask"    , areNonCommands: true, },
    { representation: "unalias"  , areNonCommands: true, },
    { representation: "wait"     , areNonCommands: true, },
]



@tokens = TokenHelper.new tokens