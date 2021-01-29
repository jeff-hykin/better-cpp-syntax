#
# alternate operator patterns
#
@double_hash          = Pattern.new(/##|%:%:|\?\?=\?\?=/)
@hash                 = Pattern.new(/##|%:|\?\?=/)
@open_square_bracket  = Pattern.new(/\[|<:|\?\?\(/)
@close_square_bracket = Pattern.new(/\[|:>|\?\?\)/)
@open_curly_brace     = Pattern.new(/\{|<%|\?\?</)
@close_curly_brace    = Pattern.new(/\}|%>|\?\?>/)
# trigraphs only
@backslash            = Pattern.new(/\\|\?\?\//)
@caret                = Pattern.new(/\^|\?\?\'/)
@pipe                 = Pattern.new(/\||\?\?!/)
@tilda                = Pattern.new(/~|\?\?-/)