// example coroutine syntax from cppreference.com
// https://en.cppreference.com/w/cpp/language/coroutines

task<> tcp_echo_server() {
	char data[1024];
	for(;;) {
		size_t n = co_await socket.async_read_some(buffer(data));
		co_await async_write(socket, buffer(data, n));
	}
}

generator<int> iota(int n = 0) {
	while(true) co_yield n++;
}

lazy<int> f() { co_return 7; }