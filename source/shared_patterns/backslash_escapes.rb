def backslash_escapes
    {
        match: "(?x)\\\\ (\n\\\\\t\t\t |\n[abefnprtv'\"?]   |\n[0-3]\\d{,2}\t |\n[4-7]\\d?\t\t|\nx[a-fA-F0-9]{,2} |\nu[a-fA-F0-9]{,4} |\nU[a-fA-F0-9]{,8} )",
        name: "constant.character.escape"
    }
end
