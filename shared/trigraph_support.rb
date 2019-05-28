#
# alternate operator patterns
#
@double_hash          = /##|%:%:|\?\?=\?\?=/
@hash                 = /##|%:|\?\?=/
@open_square_bracket  = /\[|<:|\?\?\(/
@close_square_bracket = /\[|:>|\?\?\)/
@open_curly_brace     = /\{|<%|\?\?</
@close_curly_brace    = /\}|%>|\?\?>/
# trigraphs only
@backslash            = /\\|\?\?\//
@caret                = /\^|\?\?\'/
@pipe                 = /\||\?\?!/
@tilda                = /~|\?\?-/