function ll {
    ls -lAF -h --reverse --group-directories-first --color "$@" | tac
}