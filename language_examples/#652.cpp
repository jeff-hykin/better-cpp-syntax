struct foo
{
	void (*bar1)() noexcept;
	void (*bar2)() noexcept;
	void (*bar3)() noexcept;
};

void baz()
{
	static_assert(false, "some string");
	int x = 0;
}