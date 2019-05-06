namespace test {
	template <class T>
	struct test {
		template <class U = std::vector<int>>
		bool operator()(U k) {}
	};
	struct test2 {
		bool operator()() = delete;
	};
} // namespace test

// no syntax highlighting
class test2 {};