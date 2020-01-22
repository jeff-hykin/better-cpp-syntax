module example;
import <vector>
import some.other.module;

export template<typename From, typename To>
concept convertible_to =
	std::is_convertible_v<From, To> and
	requires(From (&f)()) {
		static_cast<To>(f());
	};