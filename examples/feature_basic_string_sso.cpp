// vim:set noexpandtab tabstop=6 ft=c++
/*
    Copyright 2019

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/
#ifndef _BASIC_STRING_HPP
#define _BASIC_STRING_HPP

#include <fwd/string>
#include <cassert>
#include <cstring>
#include <algorithm>
#include <iterator>
#include <limits>
#include <memory>
#include <string_view>
#include <tuple>

namespace std {

	namespace details {
		template <class CharT>
		static constexpr size_t SSO_size = [] {
			class __long_layout {
				CharT *d;
				size_t c;
				size_t s;
			};
			return sizeof(__long_layout) / sizeof(CharT) - 1;
		}();
	}

	template <class CharT, class Traits, class Allocator>
	class basic_string {
	  public:
		using traits_type = Traits;
		using value_type = CharT;
		using allocator_type = Allocator;
		using size_type = typename std::allocator_traits<Allocator>::size_type;
		using difference_type =
		    typename std::allocator_traits<Allocator>::difference_type;
		using reference = value_type &;
		using const_reference = const value_type &;
		using pointer = typename std::allocator_traits<Allocator>::pointer;
		using const_pointer =
		    typename std::allocator_traits<Allocator>::const_pointer;
		using iterator = CharT *;
		using const_iterator = const CharT *;
		using reverse_iterator = std::reverse_iterator<iterator>;
		using const_reverse_iterator = std::reverse_iterator<const_iterator>;
		static constexpr size_t npos = -1;

	  private:
		static_assert(std::is_same_v<value_type, typename Traits::char_type>,
		              "CharT and Traits::char_type must be the same");
		static_assert(std::is_trivial_v<value_type>, "CharT must be trivial");
		// private types
		using _Sat = std::allocator_traits<Allocator>;
		using _Sv = std::basic_string_view<CharT, Traits>;
		using _UCharT = std::make_unsigned_t<CharT>;
		const static size_t _SSO_Cap = std::details::SSO_size<CharT>;
		const static size_t _size_mask =
		    (1ULL << (std::numeric_limits<size_t>::digits - 1)) - 1;
		struct _long {
			CharT *data;
			size_t capacity;
			size_t size;
		};

		struct _short {
			CharT buf[_SSO_Cap];
			_UCharT remain;
		};
		static_assert(sizeof(_long) == sizeof(_short));

		union _rep {
			_long _l;
			_short _s;
		};
		// the only member
		std::tuple<_rep, Allocator> __string;

		// helpers
		constexpr bool __is_long() const {
			return !!(std::get<0>(__string)._s.remain &
			          (1 << (std::numeric_limits<_UCharT>::digits - 1)));
		}

		constexpr const CharT *__data() const {
			return __is_long() ? std::get<0>(__string)._l.data
			                   : std::addressof(std::get<0>(__string)._s.buf[0]);
		}
		constexpr CharT *__data() {
			return __is_long() ? std::get<0>(__string)._l.data
			                   : std::addressof(std::get<0>(__string)._s.buf[0]);
		}
		constexpr size_t __capacity() const {
			return __is_long() ? std::get<0>(__string)._l.capacity : _SSO_Cap;
		}
		constexpr size_t __size() const {
			if(__is_long()) { return std::get<0>(__string)._l.size & _size_mask; }
			size_t remain = std::get<0>(__string)._s.remain;
			return _SSO_Cap - remain;
		}
		constexpr void _Set_long_size(size_t size) {
			std::get<0>(__string)._l.size = size | (_size_mask + 1);
		}
		constexpr void _Set_short_size(size_t size) {
			std::get<0>(__string)._s.remain = _SSO_Cap - size;
		}
		// if preserve is true, _Set_size can create a long form string that has a
		// length less than _SSO_Cap
		// NOTE: it is undefined behavior to set a short string's size to more than
		// _SSO_Cap when preserve is true
		constexpr void _Set_size(size_t size, bool preserve = false) {
			auto small = preserve ? !__is_long() : size <= _SSO_Cap;
			if(small) {
				_Set_short_size(size);
			} else {
				_Set_long_size(size);
			}
		}
		// determine the capacity needed such the allocation is a multiple of 16
		size_t __capacity_from_count(size_t count) {
			// returns _SSO_Cap or:
			// find the smallest multiple of 16 - 1  that is bigger than count
			if(count <= _SSO_Cap) { return _SSO_Cap; }
			return count | 15;
		}
		CharT *_New_allocate(size_t count) {
			if(count > _SSO_Cap) {
				size_type capacity = __capacity_from_count(count);
				std::get<0>(__string)._l = {
				    _Sat::allocate(std::get<1>(__string), capacity + 1), capacity,
				    count | (_size_mask + 1)};
				// technically at this point every element should be constructed
				// however CharT is required to be trivial so it is not needed.
			} else {
				std::get<0>(__string)._s.remain = _SSO_Cap - count;
			}
			return __data();
		}
		void _Deallocate() {
			if(__is_long()) {
				_Sat::deallocate(std::get<1>(__string), __data(),
				                 __capacity() + 1);
			}
			_Set_size(0);
		}
		void _Set_contents(CharT *buf, const CharT *contents, size_type count) {
			assert(!__is_long() || (void *)buf != (void *)this);
			traits_type::copy(buf, contents, count);
			traits_type::assign(buf[count], CharT());
			_Set_size(count, true);
		}
		void _Set_contents(const CharT *contents, size_type count) {
			_Set_contents(__data(), contents, count);
		}
		// always makes the string long
		void _Resize(size_t new_cap) {
			new_cap = __capacity_from_count(new_cap);
			auto buf = _Sat::allocate(std::get<1>(__string), new_cap + 1);
			_Set_contents(buf, __data(), __size() + 1);
			_Deallocate();
			std::get<0>(__string)._l = {buf, new_cap, __size() | (_size_mask + 1)};
		}
		void _Push_back(CharT elem) {
			auto size = __size();
			if(size < __capacity()) {
				auto buf = __data();
				traits_type::assign(buf[size], elem);
				traits_type::assign(buf[size + 1], CharT());
				_Set_size(size + 1);
			} else {
				// _New_allocate can't be used as the string may be short.
				auto old_cap = __capacity();
				// equivelent to ceil(cap*1.5)
				auto new_cap = old_cap + (old_cap >> 2) + (old_cap & 1);
				_Resize(new_cap);
				_Push_back(elem);
			}
		}
		// Insert [first, last) at pos
		// requires: Iterator to be at least a ForwardIterator
		// requires: capacity() >= size() + std::distance(first, last)
		template <class Iterator>
		void _Insert_no_resize(size_t pos, Iterator first, Iterator last) {
			auto distance = std::distance(first, last);
			auto buf = __data();
			traits_type::move(buf + pos + distance, buf + pos, __size() - distance);
			while(first != last) {
				traits_type::assign(buf[pos], *first);
				++pos, ++first;
			}
			_Set_size(__size() + distance);
			traits_type::assign(buf[__size()], CharT());
		}
		// Insert [first, last) at pos
		// requires: Iterator to be at least a ForwardIterator
		template <class Iterator>
		void _Insert_resize(size_t pos, Iterator first, Iterator last) {
			auto distance = std::distance(first, last);
			auto old_buf = __data();
			// calling _Resize then _Insert_no_resize would work but it would cause,
			// in the insert: aaaabbbb -> aaaaIIIIbbbb `bbbb` would be copied twice
			auto new_cap = __capacity_from_count(__size() + distance);
			auto new_buf = _Sat::allocate(std::get<1>(__string), new_cap + 1);
			// copy up to [0, pos)
			traits_type::copy(new_buf, old_buf, pos);
			while(first != last) {
				traits_type::assign(new_buf[pos], *first);
				++pos, ++first;
			}
			// copy from [pos, size) to the new buffer
			traits_type::copy(new_buf + pos + distance, old_buf + pos,
			                  __size() - distance);
			_Deallocate();
			std::get<0>(__string)._l = {new_buf, new_cap,
			                            __size() + distance | (_size_mask + 1)};
			traits_type::assign(new_buf[__size()], CharT());
		}
		// Insert [first, last) at pos
		// requires: Iterator to be at least a ForwardIterator
		template <class Iterator>
		void _Insert(size_t pos, Iterator first, Iterator last) {
			auto distance = std::distance(first, last);
			if(__size() + distance > __capacity()) {
				_Insert_resize(pos, first, last);
			} else {
				_Insert_no_resize(pos, first, last);
			}
		}

	  public:
		allocator_type get_allocator() const { return std::get<1>(__string); }
		basic_string() noexcept(noexcept(Allocator())) : basic_string(Allocator()){};
		explicit basic_string(const Allocator &alloc) noexcept
		    : __string({._s = {{}, _SSO_Cap}}, alloc){};
		// see LWG 3076 for defect report, disabling comes from libc++
		template <class = std::enable_if_t<std::__is_allocator<Allocator>::value,
		                                   nullptr_t>>
		basic_string(size_type count, CharT ch, const Allocator &alloc = Allocator())
		    : __string({}, alloc) {
			CharT *buf = _New_allocate(count);
			for(size_t s = 0; s < count; s++) { traits_type::assign(buf[s], ch); }
			traits_type::assign(buf[count], CharT());
		}
		basic_string(const basic_string &other, size_type pos,
		             const Allocator &alloc = Allocator())
		    : __string({}, alloc) {
			size_type count = other.size() - pos;
			_New_allocate(count);
			_Set_contents(other.data() + pos, count);
		}
		basic_string(const basic_string &other, size_type pos, size_type count,
		             const Allocator &alloc = Allocator())
		    : __string({}, alloc) {
			count = std::min(other.size() - pos, count);
			_New_allocate(count);
			_Set_contents(other.data() + pos, count);
		}
		basic_string(const CharT *s, size_type count,
		             const Allocator &alloc = Allocator())
		    : __string({}, alloc) {
			_New_allocate(count);
			_Set_contents(s, count);
		}
		template <class = std::enable_if_t<std::__is_allocator<Allocator>::value,
		                                   nullptr_t>>
		basic_string(const CharT *s, const Allocator &alloc = Allocator())
		    : basic_string(s, traits_type::length(s), alloc){};
		template <class InputIt,
		          std::enable_if_t<std::is_least_input_iterator<InputIt>::value,
		                           void **> = nullptr>
		basic_string(InputIt first, InputIt last,
		             const Allocator &alloc = Allocator())
		    : __string({}, alloc) {
			if constexpr(std::is_least_forward_iterator<InputIt>::value) {
				auto count = std::distance(first, last);
				CharT *buf = _New_allocate(count);
				while(first != last) {
					traits_type::assign(*buf, *first);
					++buf, (void)++first;
				}
				traits_type::assign(buf[count], CharT());
				return;
			}
			__string = {{}, alloc};
			while(first != last) {
				_Push_back(*first);
				++first;
			}
		}
		basic_string(const basic_string &other) : basic_string(other, Allocator()) {}
		basic_string(const basic_string &other, const Allocator &alloc)
		    : __string({}, alloc) {
			size_type count = other.size();
			CharT *buf = _New_allocate(count);
			traits_type::copy(buf, other.data(), count);
		}
		basic_string(basic_string &&other) noexcept
		    : basic_string(std::move(other), other.get_allocator()) {}
		basic_string(basic_string &&other, const Allocator &alloc)
		    : __string({}, alloc) {
			if(alloc != other.get_allocator()) {
				// perform new alloc then copy
				size_type count = other.size();
				CharT *buf = _New_allocate(count);
				traits_type::copy(buf, other.data(), count);
			} else {
				// this works for both short and long representations
				memcpy(this, &other, sizeof(basic_string));
				// the cheapest unspecified string is to set ._s.remain to
				// 0 that creates a _SSO_Cap length string, even if it was a long
				// before. deallocation is not needed as `this` now has control
				// of the buffers lifetime
				other._Set_size(_SSO_Cap);
			}
		}
		basic_string(std::initializer_list<CharT> ilist,
		             const Allocator &alloc = Allocator())
		    : basic_string(ilist.begin(), ilist.end(), alloc){};
		// see LWG 2946, 2758 for defect report
		template <class T, std::enable_if_t<std::is_convertible_v<const T &, _Sv>,
		                                    void **> = nullptr>
		explicit basic_string(const T &t, const Allocator &alloc = Allocator()) {
			_Sv cv = t;
			size_type count = cv.length();
			_New_allocate(count);
			_Set_contents(cv.data(), count);
		}
		template <class T,
		          std::enable_if_t<std::is_convertible<const T &, _Sv>::value,
		                           void **> = nullptr>
		basic_string(const T &t, size_type pos, size_type n,
		             const Allocator &alloc = Allocator())
		    : basic_string(_Sv(t).substr(pos, n)){};

		~basic_string() { _Deallocate(); }

		basic_string &operator=(const basic_string &str) {
			if(this == &str) { return *this; }
			if(this->__capacity() < str.__size()) {
				_Deallocate();
				_New_allocate(str.__size());
			}
			_Set_contents(str.__data(), str.__size());
			return *this;
		}
		basic_string &operator=(basic_string &&other) noexcept(
		    _Sat::propagate_on_container_move_assignment::value ||
		    _Sat::is_always_equal::value) {
			if(this == &other) { return *this; }
			if(get_allocator() != other.get_allocator() ||
			   !_Sat::propagate_on_container_move_assignment::value) {
				size_type count = other.__size();
				_New_allocate(count);
				_Set_contents(other.__data(), count);
			} else {
				memcpy(this, &other, sizeof(basic_string));
				other._Set_size(_SSO_Cap);
			}
			return *this;
		}
		basic_string &operator=(const CharT *s) {
			size_type count = Traits::length(s);
			if(this->__capacity() < count) {
				_Deallocate();
				_New_allocate(count);
			}
			_Set_contents(s, count);
			return *this;
		}
		basic_string &operator=(CharT ch) {
			_Deallocate();
			CharT *buf = _New_allocate(1);
			traits_type::assign(buf[0], ch);
			traits_type::assign(buf[1], CharT());
			return *this;
		}
		basic_string &operator=(std::initializer_list<CharT> ilist) {
			CharT *buf = __data();
			if(this->__capacity() < ilist.size()) {
				_Deallocate();
				buf = _New_allocate(count);
			}
			traits_type::copy(buf, ilist.begin(), ilist.size());
			traits_type::assign(buf[count], CharT());
			return *this;
		}
		template <class T, std::enable_if_t<
		                       std::is_convertible<const T &, _Sv>::value &&
		                           !std::is_convertible_v<const T &, const CharT *>,
		                       void **> = nullptr>
		basic_string &operator=(const T &t) {
			_Deallocate();
			_Sv cv = t;
			size_type count = cv.length();
			CharT *buf = _New_allocate(count);
			_Set_contents(cv.data(), count);
		}

		basic_string &assign(size_type count, CharT ch) {
			_Deallocate();
			CharT *buf = _New_allocate(count);
			for(size_t s = 0; s < count; s++) { traits_type::assign(buf[s], ch); }
			traits_type::assign(buf[count], CharT());
			return *this;
		}
		basic_string &assign(const basic_string &str) { return *this = str; }
		basic_string &assign(const basic_string &str, size_type pos,
		                     size_type count = npos) {
			return assign(str.substring(pos, count));
		}
		basic_string &assign(basic_string &&str) noexcept(
		    _Sat::propagate_on_container_move_assignment::value ||
		    _Sat::is_always_equal::value) {
			return *this = std::move(str);
		}
		basic_string &assign(const CharT *s, size_type count) {
			return assign(s, s + count);
		}
		basic_string &assign(const CharT *s) {
			return assign(s, traits_type::length(s));
		}
		template <class InputIt,
		          std::enable_if_t<std::is_least_input_iterator<InputIt>::value,
		                           void **> = nullptr>
		basic_string &assign(InputIt first, InputIt last) {
			_Deallocate();
			if constexpr(std::is_least_forward_iterator<InputIt>::value) {
				auto count = std::distance(first, last);
				CharT *buf = _New_allocate(count);
				while(first != last) {
					traits_type::assign(*buf, *first);
					++buf, (void)++first;
				}
				return *this;
			}
			_New_allocate(0);
			while(first != last) {
				_Push_back(*first);
				++first;
			}
			return *this;
		}
		template <class T, std::enable_if_t<std::is_convertible_v<const T &, _Sv>,
		                                    void **> = nullptr>
		basic_string &assign(const T &t, const Allocator &alloc = Allocator()) {}
		template <class T,
		          std::enable_if_t<std::is_convertible<const T &, _Sv>::value,
		                           void **> = nullptr>
		basic_string &assign(const T &t, size_type pos, size_type n,
		                     const Allocator &alloc = Allocator()) {
			return assign(_Sv(t).substr(pos, n));
		}

		reference at(size_type pos) {
			if(pos >= __size()) { throw std::out_of_range("std::basic_string"); }
			return __data()[pos];
		}
		const_reference at(size_type pos) const {
			if(pos >= __size()) { throw std::out_of_range("std::basic_string"); }
			return __data()[pos];
		}
		reference operator[](size_type pos) { return __data()[pos]; }
		const_reference operator[](size_type pos) const { return __data()[pos]; }

		reference front() { return __data()[0]; }
		const_reference front() const { return __data()[0]; }
		reference back() { return __data()[__size() - 1]; }
		const_reference back() const { return __data()[__size() - 1]; }
		CharT *data() noexcept { return __data(); }
		const CharT *data() const noexcept { return __data(); }
		const CharT *c_str() const noexcept { return __data(); }
		operator std::basic_string_view<CharT, Traits>() const noexcept {
			return std::basic_string_view<CharT, Traits>(__data(), __size());
		}

		iterator begin() noexcept { return __data(); }
		const_iterator begin() const noexcept { return __data(); }
		const_iterator cbegin() const noexcept { return __data(); }
		iterator end() noexcept { return __data() + __size(); }
		const_iterator end() const noexcept { return __data() + __size(); }
		const_iterator cend() const noexcept { return __data() + __size(); }
		iterator rbegin() noexcept { return reverse_iterator(__data()); }
		const_iterator rbegin() const noexcept { return reverse_iterator(__data()); }
		const_iterator crbegin() const noexcept { return reverse_iterator(__data()); }
		iterator rend() noexcept { return reverse_iterator(__data() + __size()); }
		const_iterator rend() const noexcept {
			return reverse_iterator(__data() + __size());
		}
		const_iterator crend() const noexcept {
			return reverse_iterator(__data() + __size());
		}

		[[nodiscard]] bool empty() const noexcept;
		size_type size() const noexcept { return __size(); }
		size_type max_size() const noexcept { return _size_mask - 2; }
		void reserve(size_type new_cap) {
			if(new_cap > __capacity()) { _Resize(new_cap); }
		}
		void reserve() {} /* NOOP */
		size_type capacity() const { return __capacity(); }
		void shrink_to_fit() {
			// dont purposely make a string long
			if(__size() > _SSO_Cap) { _Resize(__size()); }
		}

		void clear() { _Set_size(0, true); }

		basic_string &insert(size_type index, size_type count, CharT ch) {
			_Insert(index, _Repeat_iterator(ch), _Repeat_iterator(ch, count));
			return *this;
		}
		basic_string &insert(size_type index, const CharT *s) {
			auto distance = traits_type::distance(s);
			_Insert(index, s, s + distance);
			return *this;
		}
		basic_string &insert(size_type index, const CharT *s, size_type count) {
			_Insert(index, s, s + count);
			return *this;
		}
		basic_string &insert(size_type index, const basic_string &str) {
			_Insert(index, str.begin(), str.end());
			return *this;
		}
		basic_string &insert(size_type index, const basic_string &str,
		                     size_type index_str, size_type count = npos) {
			count = std::min(count, str.__size() - index_str);
			_Insert(index, str.__data() + index_str,
			        str.__data() + index_str + count);
			return *this;
		}
		iterator insert(const_iterator pos, CharT ch) {
			return insert(pos - __data(), ch, 1);
		}
		iterator insert(const_iterator pos, size_type count, CharT ch) {
			return insert(pos - __data(), ch, count);
		}
		template <class InputIt,
		          std::enable_if_t<std::is_least_input_iterator<InputIt>::value,
		                           void **> = nullptr>
		iterator insert(const_iterator pos, InputIt first, InputIt last) {
			// insert is expensive, optimize to _Push_back if can
			if(pos == end()) {
				while(first != last) {
					_Push_back(*first);
					++first;
				}
			} else {
				auto indx = pos - __data();
				while(first != last) {
					auto ch = *first;
					_Insert(indx, _Repeat_iterator(ch),
					        _Repeat_iterator(ch, 1));
					++first, (void)++indx;
				}
			}
			return *this;
		}
		iterator insert(const_iterator pos, std::initializer_list<CharT> ilist) {
			_Insert(pos - __data(), ilist.begin(), ilist.end());
			return *this;
		}
		template <class T,
		          std::enable_if_t<
		              std::is_convertible<const T &, _Sv>::value &&
		                  !std::is_convertible<const T &, const CharT *>::value,
		              void **> = nullptr>
		basic_string &insert(size_type pos, const T &t) {
			_Sv sv = t;
			return insert(pos, sv.begin(), sv.end());
		}
		template <class T,
		          std::enable_if_t<
		              std::is_convertible<const T &, _Sv>::value &&
		                  !std::is_convertible<const T &, const CharT *>::value,
		              void **> = nullptr>
		basic_string &insert(size_type index, const T &t, size_type index_str,
		                     size_type count = npos) {
			_Sv sv = _Sv(t).substr(index_str, count);
			return insert(index, sv.begin(), sv.end());
		}
		basic_string &erase(size_type index = 0, size_type count = npos) {
			count = std::min(count, __size() - index);
			if(count == 0) { return *this; }
		}
		iterator erase(const_iterator position) {}
		iterator erase(const_iterator first, const_iterator last) {}
	};
} // namespace std

#endif
