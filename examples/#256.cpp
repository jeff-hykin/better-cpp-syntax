class basic_string {
	basic_string() noexcept(noexcept(Allocator())) : basic_string(Allocator()) {}
	explicit basic_string(const Allocator &alloc) noexcept
	    : __string({._s = {{}, _SSO_Cap}}, alloc){};
	// see LWG 3076 for defect report, disabling comes from libc++
	template <
	    class = std::enable_if_t<std::__is_allocator<Allocator>::value, nullptr_t>>
	basic_string(size_type count, CharT ch, const Allocator &alloc = Allocator())
	    : __string({}, alloc) {
		CharT *buf = _New_allocate(count);
		for(size_t s = 0; s < count; s++) { traits_type::assign(buf[s], ch); }
		traits_type::assign(buf[count], CharT());
	}
};