template <bool check = !Identity, class = std::enable_if_t<check>>
result_type operator()(argument_type k) {
}
template<class A, class B = C, typename D = E>