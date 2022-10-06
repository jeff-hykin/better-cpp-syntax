struct unique_dynarray {
    unique_dynarray(const unique_dynarray&) = delete;
    unique_dynarray& operator=(const unique_dynarray&) = delete;
    unique_dynarray(unique_dynarray&&) = default;
    unique_dynarray& operator=(unique_dynarray&&) = default;
};
