struct Base {
	virtual ~Base() noexcept = default;
};

struct Derived1 : public Base {
	// Both override and noexcept are highlighted (correct)
	~Derived1() noexcept override {}
};

struct Derived2 : public Base {
	// Only noexcept is highlighted (wrong)
	~Derived2() noexcept override = default;
};

struct Derived3 : public Base {
	// Only noexcept is highlighted (wrong)
	~Derived3() noexcept final = default;
};

struct Derived4 : public Base {
	// override is not highlighted (wrong)
	~Derived4() override = default;
};

struct Derived5 : public Base {
	// final is not highlighted (wrong)
	~Derived5() final = default;
};
