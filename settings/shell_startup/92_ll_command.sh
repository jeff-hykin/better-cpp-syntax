function ll {
    ls -lAF --reverse --group-directories-first --color $@ | tac
}