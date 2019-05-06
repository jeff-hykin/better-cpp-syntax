void function() {
    if(files.size() > 1)
        throwError<std::runtime_error>("Conflicting index files ...")
}