int foo() {
	return static_cast<int>('1' + '1' - '\\' + '1');
	return static_cast<int>(u8'1' + u8'1' - u8'\\' + u8'1');
}